-- Exercicios Capitulo 5

-- 1)
ALTER TABLE cliente
ADD (cli_ch_novo CHAR(1) DEFAULT 'S' NOT NULL
         CONSTRAINT ck_cli_ch_novo CHECK(cli_ch_novo IN('S','N'))
    );
    
SELECT * FROM CLIENTE;

CREATE OR REPLACE PACKAGE pck_cliente AS

  -- Purpose : -- atualiza dados cliente
  
  -- Procedimento para atualizar valor médio de compras do cliente
  PROCEDURE AtualizarMediaComprasMensal(pCodigoCliente NUMBER);
  
  -- Procedimento para atualizar dados de maior compra do cliente
  PROCEDURE AtualizarMaiorCompra(pCodigoCliente NUMBER);
  
  -- Procedimento para atualizar status do cliente, se novo ou não
  PROCEDURE AtualizarStatusCliente;
  
  -- Função que retorna o endereço do cliente
  FUNCTION EnderecoCliente(pCodigoCliente NUMBER) RETURN VARCHAR2;
  
END pck_cliente;
/

CREATE OR REPLACE PACKAGE BODY pck_cliente AS
  -- Declaração de variáveis privadas
  
  -- Procedimento para atualizar status do cliente, se novo ou não
  PROCEDURE AtualizarStatusCliente
  IS
    CURSOR cs_cliente IS
           SELECT * FROM CLIENTE;

    vConsulta NUMBER;
    vIndice PLS_INTEGER := 0;
    vCount  PLS_INTEGER := 0;
    
    TYPE ObjCliente AS OBJECT
    (Codigo INTEGER,
     Nome VARCHAR2(20),
     Novo CHAR(1)
    );
    
    TYPE TCliente IS TABLE OF ObjCliente;
    
    cCli TCliente;
    BEGIN
      cCli := TCliente();
      
      FOR csc IN cs_cliente LOOP
        cCli.EXTEND;
        
        vIndice := cCli.LAST;
        
        -- Inicializa a variavel
        cCli(vIndice) := ObjCliente(NULL,NULL,NULL);
        
        cCli(vIndice).Codigo := csc.cli_in_codigo;
        cCli(vIndice).Nome := csc.cli_st_nome;
        IF csc.cli_dt_inclusao BETWEEN add_months(trunc(SYSDATE),-12) AND SYSDATE
          cCli(vIndice).Novo := 'S';
        ELSE
          cCli(vIndice).Novo := 'N';
        END IF; 
      END LOOP;
    END;
  /
  
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
  
  -- Função que recebe codigo do cliente e retorna codigo do produto com maior frequencia de compra
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
  
   -- Função que recebe codigo do cliente e retorna codigo do produto com maior representividade financeira para o cliente
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