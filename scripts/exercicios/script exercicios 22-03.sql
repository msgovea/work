-- 1)
CREATE OR REPLACE FUNCTION mgovea.fnValorTotalItensNotaFiscal (codigoNF NUMBER)
RETURN NUMBER IS
    vValor ITEM_NOTA_FISCAL_VENDA.INFV_VL_TOTAL%TYPE;
    vTotal ITEM_NOTA_FISCAL_VENDA.INFV_VL_TOTAL%TYPE;
    
    CURSOR cs_totalItens(codigoNF NUMBER) IS
      SELECT INFV_VL_TOTAL FROM ITEM_NOTA_FISCAL_VENDA WHERE NFV_IN_NUMERO = codigoNF; 
  BEGIN
    OPEN cs_totalItens(codigoNF);
    vTotal := 0;
    LOOP
      FETCH cs_totalItens INTO vValor;
      EXIT WHEN cs_totalItens%NOTFOUND;
      
      vTotal := vTotal + vValor;  
    END LOOP;
    RETURN(vTotal);
    COMMIT;
  END;
  /
  
SELECT mgovea.fnValorTotalItensNotaFiscal(11111) FROM DUAL;

-----
-- 2)
CREATE OR REPLACE PROCEDURE mgovea.prAtualizarValorNotaFiscal
  IS 
    CURSOR cs_totalNF IS
      SELECT nfv.NFV_VL_TOTAL, nfv.NFV_IN_NUMERO 
      FROM NOTA_FISCAL_VENDA nfv;
      
    rNota cs_totalNF%ROWTYPE;
    vTotalReal NOTA_FISCAL_VENDA.NFV_VL_TOTAL%TYPE;
  BEGIN 
    OPEN CS_TOTALNF;
    LOOP
      FETCH cs_totalnf INTO rNota;
      EXIT WHEN CS_TOTALNF%NOTFOUND;
      
      vTotalReal := mgovea.fnValorTotalItensNotaFiscal(rNota.NFV_IN_NUMERO);
      
      IF rNota.NFV_VL_TOTAL != vTotalReal
       THEN
        UPDATE NOTA_FISCAL_VENDA
          SET NFV_VL_TOTAL = vTotalReal
          WHERE NFV_IN_NUMERO = rNota.NFV_IN_NUMERO;
      END IF;    
    END LOOP;
    COMMIT;
  END;
/
  
  BEGIN
  mgovea.prAtualizarValorNotaFiscal;
  end;
  /
      
UPDATE NOTA_FISCAL_VENDA NFV 
  SET NFV.NFV_VL_TOTAL = 10
    WHERE NFV_IN_NUMERO = 11111;
    
-----------------------------------
-- 3)

CREATE OR REPLACE PACKAGE mgovea.pck_NotaFiscalVenda AS

  FUNCTION fnValorTotalItensNotaFiscal(pCodigoNF NUMBER) RETURN NUMBER;

  PROCEDURE prAtualizarValorItem;
  
  PROCEDURE prAtualizarValorNotaFiscal;
  
END pck_NotaFiscalVenda;
/

CREATE OR REPLACE PACKAGE BODY mgovea.pck_NotaFiscalVenda AS
  -- Declara��o de vari�veis privadas
  
  -- Fun��o que retorna o valor total dos itens em uma determinada nota fiscal
  FUNCTION fnValorTotalItensNotaFiscal (pCodigoNF NUMBER)
  RETURN NUMBER IS
    vValor ITEM_NOTA_FISCAL_VENDA.INFV_VL_TOTAL%TYPE;
    vTotal ITEM_NOTA_FISCAL_VENDA.INFV_VL_TOTAL%TYPE;
    
    CURSOR cs_totalItens(pCodigoNF NUMBER) IS
      SELECT INFV_VL_TOTAL FROM ITEM_NOTA_FISCAL_VENDA WHERE NFV_IN_NUMERO = pCodigoNF; 
  BEGIN
    OPEN cs_totalItens(pCodigoNF);
    vTotal := 0;
    LOOP
      FETCH cs_totalItens INTO vValor;
      EXIT WHEN cs_totalItens%NOTFOUND;
      
      vTotal := vTotal + vValor;  
    END LOOP;
    RETURN(vTotal);
  END;
  
  -- Procedimento para atualizar o valor total do item caso esteja incorreto
  PROCEDURE prAtualizarValorItem
  IS 
    CURSOR cs_item_note_fiscal_venda IS
      SELECT infv.INFV_QT_FATURADA, infv.INFV_VL_UNITARIO,
             infv.INFV_PE_DESCONTO, infv.INFV_VL_TOTAL,
             infv.INFV_IN_NUMERO
      FROM ITEM_NOTA_FISCAL_VENDA infv;
      
    rItem cs_item_note_fiscal_venda%ROWTYPE;
    vTotalItem ITEM_NOTA_FISCAL_VENDA.INFV_VL_TOTAL%TYPE;
    vTotalReal ITEM_NOTA_FISCAL_VENDA.INFV_VL_TOTAL%TYPE;
  BEGIN 
    OPEN cs_item_note_fiscal_venda;
    LOOP
      FETCH cs_item_note_fiscal_venda INTO rItem;
      EXIT WHEN cs_item_note_fiscal_venda%NOTFOUND;
      
      vTotalItem := rItem.INFV_VL_TOTAL;
      vTotalReal := (rItem.INFV_QT_FATURADA * rItem.INFV_VL_UNITARIO) * 1 - (rItem.INFV_PE_DESCONTO / 100);
      
      IF vTotalReal != vTotalItem
       THEN
        UPDATE ITEM_NOTA_FISCAL_VENDA
          SET INFV_VL_TOTAL = vTotalReal
          WHERE INFV_IN_NUMERO = rItem.INFV_IN_NUMERO;
      END IF;    
    END LOOP;
    COMMIT;
  END;
  
  -- Procedimento para atualizar o valor da nota caso esteja desatualizado
  PROCEDURE prAtualizarValorNotaFiscal
  IS 
    CURSOR cs_totalNF IS
      SELECT nfv.NFV_VL_TOTAL, nfv.NFV_IN_NUMERO 
      FROM NOTA_FISCAL_VENDA nfv;
      
    rNota cs_totalNF%ROWTYPE;
    vTotalReal NOTA_FISCAL_VENDA.NFV_VL_TOTAL%TYPE;
  BEGIN 
    OPEN CS_TOTALNF;
    LOOP
      FETCH cs_totalnf INTO rNota;
      EXIT WHEN CS_TOTALNF%NOTFOUND;
      
      
      vTotalReal := fnValorTotalItensNotaFiscal(rNota.NFV_IN_NUMERO);
      
      IF rNota.NFV_VL_TOTAL != vTotalReal
       THEN
        prAtualizarValorItem();
        UPDATE NOTA_FISCAL_VENDA
          SET NFV_VL_TOTAL = vTotalReal
          WHERE NFV_IN_NUMERO = rNota.NFV_IN_NUMERO;
      END IF;    
    END LOOP;
    COMMIT;
  END;
  
END pck_NotaFiscalVenda;
/

begin
  PCK_NOTAFISCALVENDA.PRATUALIZARVALORNOTAFISCAL;
end;
/

-------------
-- 4)
CREATE OR REPLACE PROCEDURE mgovea.prAtualizarVendasMensal(pAno DATE, pMes DATE)
IS
  vAno DATE := to_date(trunc(pAno, 'YYYY'));
  vMes DATE := to_date(trunc(pAno, 'MM'));
  
  CURSOR cs_notaFiscalVenda IS 
    SELECT * FROM NOTA_FISCAL_VENDA
       WHERE to_date(trunc(vAno, 'YYYY')) = to_date(trunc(NFV_DT_EMISSAO, 'YYYY'))
             AND to_date(trunc(vMes, 'MM')) = to_date(trunc(NFV_DT_EMISSAO, 'MM'));
             
  CURSOR cs_resumoMensalVenda IS 
    SELECT * FROM RESUMO_MENSAL_VENDA
       WHERE RMV_IN_MES = to_char(trunc(vAno, 'YYYY')) AND
                        RMV_IN_ANO = to_char(trunc(vMes, 'MM'));
                        
  CURSOR cs_produto IS 
    SELECT INFV.INFV_VL_TOTAL, NFV.CLI_IN_CODIGO, NFV.REP_IN_CODIGO, INFV.PRO_IN_CODIGO
             FROM ITEM_NOTA_FISCAL_VENDA INFV, NOTA_FISCAL_VENDA NFV
             WHERE NFV.NFV_IN_NUMERO = INFV.NFV_IN_NUMERO
             order by INFV.pro_in_codigo;                                
             
  vNotaFiscal cs_notaFiscalVenda%ROWTYPE;
  vResumoMensal cs_resumoMensalVenda%ROWTYPE;
  vProduto cs_rpdouto%ROWTYPE;
  
  BEGIN
    OPEN cs_notaFiscalVenda; 
    LOOP
      FETCH CS_NOTAFISCALVENDA INTO vNotaFiscal;
      EXIT WHEN CS_NOTAFISCALVENDA%NOTFOUND;
      --
           LOOP 
             FETCH CS_PRODUTO INTO vProduto;
             EXIT WHEN CS_PRODUTO%NOTFOUND;
             
             LOOP
               FETCH CS_RESUMOMENSALVENDAS INTO vResumoMensal;
               EXIT WHEN CS_RESUMOMENSALVENDAS%ROWTYPE;
             END LOOP;

             SELECT * FROM ITEM_NOTA_FISCAL_VENDA
	     -- Falta terminar este exercicio

           END LOOP;
           dbms_output.put_line(vNotaFiscal.REP_IN_CODIGO || ' ');
      --
    END LOOP;
    CLOSE cs_notaFiscalVenda;
    commit;
  END;
/

begin
  mgovea.prAtualizarVendasMensal(sysdate, sysdate);
end;
/

-- 5)
CREATE OR REPLACE PACKAGE pck_cliente AS

  PROCEDURE prAtualizaDados(pCodigoCliente NUMBER);
 
  FUNCTION fnProdutoMaiorFrequencia(pCodigoCliente NUMBER) RETURN NUMBER;

  FUNCTION fnProdutoMaiorRepresentividade(pCodigoCliente NUMBER) RETURN NUMBER;
 
END pck_cliente;
/

CREATE OR REPLACE PACKAGE BODY pck_cliente AS
  -- Declara��o de vari�veis privadas
  
  -- Procedimento que atualiza dados do cliente
  PROCEDURE prAtualizaDados(pCodigoCliente NUMBER)
  IS
    CURSOR cs_cliente IS
           SELECT * FROM CLIENTE;

    CURSOR cs_vendas(pCodCliente NUMBER) IS
           SELECT * FROM NOTA_FISCAL_VENDA
           WHERE pCodCliente = CLI_IN_CODIGO;

    vConsulta NUMBER;
    BEGIN
      SELECT avg(rmv_vl_total) INTO vConsulta FROM RESUMO_MENSAL_VENDA
      WHERE pCodigoCliente = CLI_IN_CODIGO;        
      
      FOR rCliente IN cs_cliente LOOP
        FOR rVendas IN cs_vendas(pCodigoCliente) LOOP
          IF rCliente.CLI_VL_MAIORCOMPRA != rVendas.NFV_VL_TOTAL THEN
            UPDATE CLIENTE
                   SET CLI_VL_MAIORCOMPRA = rVendas.NFV_VL_TOTAL
                   WHERE CLIENTE.CLI_IN_CODIGO = pCodigoCliente;
          END IF;
          IF rCliente.CLI_DT_MAIORCOMPRA != rVendas.NFV_DT_EMISSAO
            AND rVendas.NFV_VL_TOTAL = rCliente.CLI_VL_MAIORCOMPRA THEN

            UPDATE CLIENTE
                   SET CLI_DT_MAIORCOMPRA = rVendas.NFV_DT_EMISSAO
                   WHERE CLIENTE.CLI_IN_CODIGO = pCodigoCliente;
          END IF;

          IF rCliente.CLI_VL_MEDIACOMPRASMENSAL != vConsulta THEN
             UPDATE CLIENTE
                  SET CLIENTE.CLI_VL_MEDIACOMPRASMENSAL = vConsulta
                   WHERE CLIENTE.CLI_IN_CODIGO = pCodigoCliente;
          END IF;
        END LOOP;
      END LOOP;
    END;
  /    
  
  -- Fun��o que recebe codigo do cliente e retorna codigo do produto com maior frequencia de compra
  FUNCTION fnProdutoMaiorFrequencia(pCodigoCliente NUMBER)
  RETURN NUMBER IS
      
    CURSOR cs_produtoMaiorFrequencia(pCodigoCliente NUMBER) IS
    SELECT pro_in_codigo, COUNT(pro_in_codigo)quantidade 
           FROM item_nota_fiscal_venda infv, nota_fiscal_venda nfv
           WHERE nfv.nfv_in_numero = infv.nfv_in_numero
                 AND nfv.cli_in_codigo = pCodigoCliente
           GROUP BY pro_in_codigo 
           ORDER BY pro_in_codigo;
    vProduto cs_produtoMaiorFrequencia%ROWTYPE;
    vProdutoMaiorFrequencia cs_produtoMaiorFrequencia%ROWTYPE;
  BEGIN
    OPEN cs_produtoMaiorFrequencia(pCodigoCliente);
    
    FETCH cs_produtoMaiorFrequencia INTO vProduto;
    vProdutoMaiorFrequencia := vProduto;
    LOOP
      FETCH cs_produtoMaiorFrequencia INTO vProduto;
      EXIT WHEN cs_produtoMaiorFrequencia%NOTFOUND;
      
      IF vProduto.quantidade > vProdutoMaiorFrequencia.quantidade THEN
        vProdutoMaiorFrequencia := vProduto;
    END LOOP;
    RETURN(vProdutoMaiorFrequencia.pro_in_codigo);
  END;
  
   -- Fun��o que recebe codigo do cliente e retorna codigo do produto com maior representividade financeira para o cliente
  FUNCTION fnProdutoMaiorFrequencia(pCodigoCliente NUMBER)
  RETURN NUMBER IS
      
    CURSOR cs_produtoMaiorFrequencia(pCodigoCliente NUMBER) IS
    SELECT pro_in_codigo, COUNT(pro_in_codigo)quantidade 
           FROM item_nota_fiscal_venda infv, nota_fiscal_venda nfv
           WHERE nfv.nfv_in_numero = infv.nfv_in_numero
                 AND nfv.cli_in_codigo = pCodigoCliente
           GROUP BY pro_in_codigo 
           ORDER BY pro_in_codigo;
    vProduto cs_produtoMaiorFrequencia%ROWTYPE;
    vProdutoMaiorFrequencia cs_produtoMaiorFrequencia%ROWTYPE;
  BEGIN
    OPEN cs_produtoMaiorFrequencia(pCodigoCliente);
    
    FETCH cs_produtoMaiorFrequencia INTO vProduto;
    vProdutoMaiorFrequencia := vProduto;
    LOOP
      FETCH cs_produtoMaiorFrequencia INTO vProduto;
      EXIT WHEN cs_produtoMaiorFrequencia%NOTFOUND;
      
      IF vProduto.quantidade > vProdutoMaiorFrequencia.quantidade THEN
        vProdutoMaiorFrequencia := vProduto;
      END IF;
    END LOOP;
    RETURN(vProdutoMaiorFrequencia.pro_in_codigo);
  END;
    
END pck_cliente;


-- 7)
CREATE OR REPLACE PACKAGE pck_produto AS

  PROCEDURE prAtualizaDataValorUltimaVenda;
 
  PROCEDURE prAtualizaDataValorMaiorVenda;
  
END pck_produto;
/

CREATE OR REPLACE PACKAGE BODY pck_produto AS
  -- Declara��o de vari�veis privadas
  
  -- Procedimento que atualiza dados de ultima venda do produto
  PROCEDURE prAtualizaDataValorUltimaVenda
  IS
    vUltimaVenda NUMBER;
    vDataUltimaVenda DATE;
    
    CURSOR cs_ultimaVenda IS
           SELECT MAX(NFV.NFV_DT_EMISSAO)ULTIMA_DATA, INFV.INFV_VL_TOTAL VALOR_ULTIMA_VENDA, PRO_IN_CODIGO
           FROM ITEM_NOTA_FISCAL_VENDA INFV, NOTA_FISCAL_VENDA NFV
           WHERE NFV.NFV_IN_NUMERO = INFV.NFV_IN_NUMERO
           GROUP BY INFV.PRO_IN_CODIGO, infv.infv_vl_total
           ORDER BY INFV.PRO_IN_CODIGO;

    BEGIN
      FOR rUltimaVenda IN cs_ultimaVenda LOOP
        SELECT PRO_VL_ULTIMAVENDA INTO vUltimaVenda FROM PRODUTO WHERE PRO_IN_CODIGO = rUltimaVenda.Pro_In_Codigo;
        SELECT PRO_DT_ULTIMAVENDA INTO vDataUltimaVenda FROM PRODUTO WHERE PRO_IN_CODIGO = rUltimaVenda.Pro_In_Codigo;
         IF rUltimaVenda.VALOR_ULTIMA_VENDA != vUltimaVenda THEN
            UPDATE PRODUTO
                   SET PRO_VL_ULTIMAVENDA = rUltimaVenda.VALOR_ULTIMA_VENDA
                   WHERE PRODUTO.PRO_IN_CODIGO = rUltimaVenda.PRO_IN_CODIGO;
         END IF;
         IF rUltimaVenda.ULTIMA_DATA != vDataUltimaVenda THEN
            UPDATE PRODUTO
                   SET PRO_DT_ULTIMAVENDA = rUltimaVenda.ULTIMA_DATA
                   WHERE PRODUTO.PRO_IN_CODIGO = rUltimaVenda.PRO_IN_CODIGO;
         END IF;
      END LOOP;
    END;
    
 -- Procedimento que atualiza dados da maior venda do produto
  PROCEDURE prAtualizaDataValorMaiorVenda IS
    vMaiorVenda NUMBER;
    vDataMaiorVenda DATE;
    CURSOR cs_maiorVenda IS
           SELECT MAX(INFV.INFV_VL_TOTAL)VALOR_MAIOR_VENDA, NFV.NFV_DT_EMISSAO DATA_MAIOR_VENDA, PRO_IN_CODIGO
           FROM ITEM_NOTA_FISCAL_VENDA INFV, NOTA_FISCAL_VENDA NFV
           WHERE NFV.NFV_IN_NUMERO = INFV.NFV_IN_NUMERO
           GROUP BY INFV.PRO_IN_CODIGO, nfv.nfv_dt_emissao
           ORDER BY INFV.PRO_IN_CODIGO;

    BEGIN
      FOR rMaiorVenda IN cs_maiorVenda LOOP
        SELECT PRO_VL_MAIORVENDA INTO vMaiorVenda     FROM PRODUTO WHERE PRO_IN_CODIGO = rMaiorVenda.Pro_In_Codigo;
        SELECT PRO_DT_MAIORVENDA INTO vDataMaiorVenda FROM PRODUTO WHERE PRO_IN_CODIGO = rMaiorVenda.Pro_In_Codigo;

        IF rMaiorVenda.VALOR_MAIOR_VENDA != vMaiorVenda THEN
           UPDATE PRODUTO
                   SET PRO_VL_MAIORVENDA = rMaiorVenda.VALOR_MAIOR_VENDA
                   WHERE PRODUTO.PRO_IN_CODIGO = rMaiorVenda.PRO_IN_CODIGO;
        END IF;
        IF rMaiorVenda.DATA_MAIOR_VENDA != vDataMaiorVenda THEN
            UPDATE PRODUTO
                   SET PRO_DT_MAIORVENDA = rMaiorVenda.DATA_MAIOR_VENDA
                   WHERE PRODUTO.PRO_IN_CODIGO = rMaiorVenda.PRO_IN_CODIGO;
        END IF;
      END LOOP;
    END;
  /    

END pck_produto;