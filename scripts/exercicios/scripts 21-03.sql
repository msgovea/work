CREATE OR REPLACE PACKAGE pck_cliente AS

  -- Purpose : -- atualiza dados cliente
  
  /*--------------------------------------------------------------------------*/
  /* Public function and procedure declarations */
  /*--------------------------------------------------------------------------*/
  
  -- Procedimento para atualizar valor médio de compras do cliente
  PROCEDURE AtualizarMediaComprasMensal(pCodigoCliente NUMBER);
  
  -- Procedimento para atualizar dados de maior compra do cliente
  PROCEDURE AtualizarMaiorCompra(pCodigoCliente NUMBER);
  
  -- Função que retorna o endereço do cliente
  FUNCTION EnderecoCliente(pCodigoCliente NUMBER) RETURN VARCHAR2;
  
END pck_cliente;
/



CREATE OR REPLACE PACKAGE BODY pck_cliente AS
  -- Declaração de variáveis privadas
  rCli cliente%ROWTYPE;
  -- Procedimento para atualizar valor médio de compras do cliente
  PROCEDURE AtualizarMediaComprasMensal(pCodigoCliente NUMBER) IS
  BEGIN
    -- Recupera a média a partir da soma mensal
    SELECT AVG(rmv_vl_total)
    INTO rCli.cli_vl_mediacomprasmensal
    FROM (SELECT rmv_in_mes,
                 rmv_in_ano,
                 sum(rmv_vl_total) rmv_vl_total
          FROM resumo_mensal_venda
          WHERE cli_in_codigo = pCodigoCliente
          GROUP BY rmv_in_mes,
                   rmv_in_ano
          );
          
    -- Atualiza Média Compras Mensal
    UPDATE cliente
    SET cli_vl_mediacomprasmensal = rCli.cli_vl_mediacomprasmensal
    WHERE cli_in_codigo = pCodigoCliente;
    
    -- Finaliza transação confirmando alterações
    COMMIT;
  END;
  
  -- Procedimento para atualizar dados de maior compra do cliente
  PROCEDURE AtualizarMaiorCompra(pCodigoCliente NUMBER) IS
  BEGIN
    -- Recupera a maior compra do cliente
    SELECT MAX(nfv_vl_total)
    INTO rCli.cli_vl_maiorcompra
    FROM nota_fiscal_venda
    WHERE cli_in_codigo = pCodigoCliente;
    
    -- Atualiza Maior Compra do cliente
    UPDATE cliente
    SET cli_vl_maiorcompra = rCli.cli_vl_maiorcompra
    WHERE cli_in_codigo = pCodigoCliente;
    
    -- Finaliza transação confirmando alterações
    COMMIT;
  END;
  
  -- Função que retorna o endereço do cliente
  FUNCTION EnderecoCliente(pCodigoCliente NUMBER) RETURN VARCHAR2 IS
    vEnderecoCliente VARCHAR2(256);
  BEGIN
    -- Recupera o endereço concatenado do cliente
    SELECT cli_st_endereco ||' - '||cli_st_cidade ||' - '||cli_st_uf
    INTO vEnderecoCliente
    FROM cliente
    WHERE cli_in_codigo = pCodigoCliente;
    
    -- Retorna o endereço concatenado
    RETURN(vEnderecoCliente);
  END;
END pck_cliente;
/

-----------------------------------

-- Exercícios Propostos 3

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
  -- Declaração de variáveis privadas
  
  -- Função que retorna o valor total dos itens em uma determinada nota fiscal
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
CREATE OR REPLACE PACKAGE mgovea.pck_cliente AS

  PROCEDURE prAtualizaDados(pCodigoCliente NUMBER);
 
  FUNCTION fnProdutoMaiorFrequencia(pCodigoCliente NUMBER) RETURN NUMBER;

  FUNCTION fnProdutoMaiorRepresentividade(pCodigoCliente NUMBER) RETURN NUMBER;
 
END pck_cliente;
/

CREATE OR REPLACE PACKAGE BODY mgovea.pck_cliente AS
  -- Declaração de variáveis privadas
  
  -- Procedimento que atualiza dados do cliente
  PROCEDURE prAtualizaDados(pCodigoCliente NUMBER)
  IS
    CURSOR cs_cliente IS
           SELECT * FROM CLIENTE;
           
    CURSOR cs_vendas(pCodCliente NUMBER) IS
           SELECT * FROM NOTA_FISCAL_VENDA
           WHERE pCodCliente = CLI_IN_CODIGO;
           
    CURSOR cs_resumo(pCodCliente NUMBER) IS
           SELECT avg(rmv_vl_total) FROM RESUMO_MENSAL_VENDA
           WHERE pCodCliente = CLI_IN_CODIGO;       
  
    BEGIN
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
          
        
        END IF;
      END LOOP;
    END;
    /         
  
  -- Função que retorna o valor total dos itens em uma determinada nota fiscal
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
    
END pck_cliente;




begin
  PCK_NOTAFISCALVENDA.PRATUALIZARVALORNOTAFISCAL;
end;
/
-- CONTINUA ....

SELECT to_char(trunc(sysdate,'yyyy'), 'yy') FROM NOTA_FISCAL_VENDA
       WHERE to_date(trunc(sysdate, 'YYYY')) = to_date(trunc(NFV_DT_EMISSAO, 'YYYY'))
             AND to_date(trunc(sysdate, 'MM')) = to_date(trunc(NFV_DT_EMISSAO, 'MM'));


SELECT * FROM NOTA_FISCAL_VENDA
       WHERE to_date(trunc(sysdate, 'YYYY')) = to_date(trunc(NFV_DT_EMISSAO, 'YYYY'))
             AND to_date(trunc(sysdate, 'MM')) = to_date(trunc(NFV_DT_EMISSAO, 'MM'));

SELECT * FROM NOTA_FISCAL_VENDA;

SELECT * FROM RESUMO_MENSAL_VENDA;

SELECT * FROM CLIENTE;

SELECT * FROM ITEM_NOTA_FISCAL_VENDA;

UPDATE ITEM_NOTA_FISCAL_VENDA
  SET INFV_PE_DESCONTO = 00
  WHERE PRO_IN_CODIGO = 1;