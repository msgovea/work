Apostila 2

-- Exercicios propostos - 1 

-- 1)

DECLARE
    vQtd NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO vQtd FROM CLIENTE;
    dbms_output.put_line('Na tabela Cliente, existem '||vQtd||' registros!');
END;
/

-- 2)
-- ok

-- 3)
DECLARE 
   vValor NUMBER := 0;
BEGIN
   dbms_output.put_line(vValor);
   DECLARE 
      vValor NUMBER := 10;
   BEGIN
      dbms_output.put_line(vValor);
   END;
END;
/

-- 4)
DECLARE
   vDataNascimento DATE := '14/11/1996';
BEGIN
   dbms_output.put_line(round((sysdate - vDataNascimento) / 365));
END;
/

-- 5)

DECLARE
   TYPE TPessoa IS RECORD(
     Nome VARCHAR2(40) ,
     DataNascimento DATE,
     Idade NUMBER
   );
   vPessoa TPessoa;
BEGIN
   vPessoa.Nome := 'Mateus Sauer Govêa';
   vPessoa.DataNascimento := '14/11/1996';
   
   vPessoa.Idade := round((sysdate - vPessoa.DataNascimento)/ 365);
   
   dbms_output.put_line('------ TPessoa ------'||chr(10)||
                        'Nome: ' || vPessoa.Nome||chr(10)||
                        'Data Nascimento: ' || vPessoa.DataNascimento||chr(10)||
                        'Idade: '|| vPessoa.Idade);
END;
/

-- 6)

DECLARE
   vCliente CLIENTE%ROWTYPE;
   vCodeError NUMBER;
   vMessageError VARCHAR2(50);
BEGIN
   SELECT * INTO vCliente FROM CLIENTE
   WHERE CLIENTE.CLI_IN_CODIGO IN(10,20,30,40,50);
   
   dbms_output.put_line('------ CLIENTE ------'||chr(10)||
                        'Codigo: ' || vCliente.CLI_IN_CODIGO||chr(10)||
                        'Nome: ' || vCliente.CLI_ST_NOME||chr(10)||
                        'Endereço: ' || vCliente.CLI_ST_ENDERECO||chr(10)||
                        'Ramo Atividade: '|| vCliente.CLI_ST_RAMOATIVIDADE);
EXCEPTION
    WHEN too_many_rows THEN
      DBMS_OUTPUT.put_line('Muitas linhas retornadas!');
    WHEN no_data_found THEN
      DBMS_OUTPUT.put_line('Sem retorno de dados');
    WHEN OTHERS THEN
      ROLLBACK;
      vCodeError := SQLCODE;
      vMessageError := SQLERRM;
      -- Imprime na tela o código do erro e a mensagem
      dbms_output.put_line('Cód.Erro: '||to_char(vCodeError)||chr(10)||
      'Mensagem: '||vMessageError
      );
END;
/


-- Exercicios Propostos 2

-- 1)

DECLARE
   CURSOR cs_cliente(atividades VARCHAR2) is
    SELECT c.*
    FROM cliente c
    WHERE c.cli_st_ramoatividade = atividades;
    
  -- declaração de variáveis
  rCli cs_cliente%ROWTYPE;
BEGIN
  dbms_output.put_line('----- Hipermercado ----- ');
       -- Imprime dados extraídos na tela
  FOR rCli in cs_Cliente('HIPERMERCADO') LOOP
       IF TRUNC(rCli.CLI_DT_MAIORCOMPRA, 'MM') = TRUNC(SYSDATE, 'MM') THEN
          dbms_output.put_line('A maior compra do cliente ' || rCli.cli_in_codigo || ' foi realizada no mês corrente.' );
       END IF;
  END LOOP;
  
  dbms_output.put_line('----- Supermercado ----- ');
       -- Imprime dados extraídos na tela
  FOR rCli in cs_Cliente('SUPERMERCADO') LOOP
       IF TRUNC(rCli.CLI_DT_MAIORCOMPRA, 'MM') = TRUNC(SYSDATE, 'MM') THEN
          dbms_output.put_line('A maior compra do cliente ' || rCli.cli_in_codigo || ' foi realizada no mês corrente.' );
       END IF;
  END LOOP;
  
  dbms_output.put_line('----- Mercado ----- ');
       -- Imprime dados extraídos na tela
  FOR rCli in cs_Cliente('MERCADO') LOOP
       IF TRUNC(rCli.CLI_DT_MAIORCOMPRA, 'MM') = TRUNC(SYSDATE, 'MM') THEN
          dbms_output.put_line('A maior compra do cliente ' || rCli.cli_in_codigo || ' foi realizada no mês corrente.' );
       END IF;
  END LOOP;
  
  dbms_output.put_line('----- Mercearia ----- ');
       -- Imprime dados extraídos na tela
  FOR rCli in cs_Cliente('MERCEARIA') LOOP
       IF TRUNC(rCli.CLI_DT_MAIORCOMPRA, 'MM') = TRUNC(SYSDATE, 'MM') THEN
          dbms_output.put_line('A maior compra do cliente ' || rCli.cli_in_codigo || ' foi realizada no mês corrente.' );
       END IF;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    
    DBMS_OUTPUT.put_line('erro' || SQLCODE || SQLERRM);
END;

-- 2)

DECLARE
   CURSOR CS_PRODUTO IS
          SELECT * FROM PRODUTO;
   vProduto PRODUTO%ROWTYPE;

BEGIN
  OPEN CS_PRODUTO;
  
  LOOP 
    -- PASSA LINHA DO 
    FETCH CS_PRODUTO INTO vProduto;
    
    -- SE NÃO ENCONTRADO LINHA DO CS_PRODUTO SAI DO LOOP
    EXIT WHEN CS_PRODUTO%NOTFOUND;
    
    -- VERIFICA SE A ULTIMA VENDA FOI A MAIOR VENDA
    IF vProduto.PRO_VL_ULTIMAVENDA >= vProduto.PRO_VL_MAIORVENDA THEN
      dbms_output.put_line('Novo record de venda do produto '|| vProduto.PRO_IN_CODIGO ||' é '|| vProduto.PRO_VL_MAIORVENDA);
    -- SE NÃO FOR A MAIOR VENDA.
    ELSE 
      dbms_output.put_line('O record de venda do produto '|| vProduto.PRO_IN_CODIGO ||' não foi alcançado');
    END IF;
  END LOOP;
  CLOSE CS_PRODUTO;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('ERRO');
END;
    
-- 3)
DECLARE
   CURSOR CS_REPRESENTANTE IS 
          SELECT * FROM REPRESENTANTE;
          
   vRepresentante REPRESENTANTE%ROWTYPE;

BEGIN
  OPEN CS_REPRESENTANTE;
  
  LOOP
    FETCH CS_REPRESENTANTE INTO vRepresentante;
    
    EXIT WHEN CS_REPRESENTANTE%NOTFOUND; 
    
    IF vRepresentante.REP_VL_METAMENSAL < vRepresentante.REP_VL_MEDIAMENSALVENDAS THEN
      dbms_output.put_line('A meta mensal de vendas do representante '|| vRepresentante.REP_IN_CODIGO ||' está abaixo de sua média mensal');
    ELSIF vRepresentante.REP_VL_METAMENSAL > vRepresentante.REP_VL_MEDIAMENSALVENDAS AND 
          vRepresentante.REP_VL_METAMENSAL < vRepresentante.REP_VL_MAIORVENDA THEN
      dbms_output.put_line('O representante '|| vRepresentante.REP_IN_CODIGO ||' tem potencial maior do que sua meta mensal.');   
    ELSE
      dbms_output.put_line('O representante '|| vRepresentante.REP_IN_CODIGO ||' atingiu todo o potencial de vendas!');
    END IF;         
          
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line('Erro');
END;  

-- 4)

DECLARE
   vData DATE;
BEGIN
  vData := TRUNC(sysdate, 'MM');
  dbms_output.put_line(vData);
  
  LOOP
    -- ADICIONA 1 DIA A VARIAVEL DATA
    vData := vData +1;
    dbms_output.put_line(vData);
    
    -- LOOP SE ENCERRA QUANDO A DATA FOR IGUAL AO ULTIMO DIA DO MÊS
    EXIT WHEN TRUNC(vData, 'dd') = LAST_DAY(vData);
        
  END LOOP;
END;

-- 5)

DECLARE

  vData DATE;

  FUNCTION IncrementaData(pData DATE)
  RETURN DATE IS
    vData DATE;
  BEGIN
    vData := pData + 1;
    
    RETURN(vData);
  END;
  
   
BEGIN
  vData := TRUNC(sysdate, 'MM');
  dbms_output.put_line(vData);
  
  LOOP
    -- ADICIONA 1 DIA A VARIAVEL DATA
    vData := IncrementaData(vData);
    dbms_output.put_line(vData);
    
    -- LOOP SE ENCERRA QUANDO A DATA FOR IGUAL AO ULTIMO DIA DO MÊS
    EXIT WHEN TRUNC(vData, 'dd') = LAST_DAY(vData);
        
  END LOOP;
END;


