SELECT * FROM CLIENTE;

SELECT * FROM ITEM_NOTA_FISCAL_VENDA;

SELECT * FROM LOG_PRECO_PRODUTO;

SELECT * FROM NOTA_FISCAL_VENDA;

SELECT * FROM PRECO_PRODUTO;

SELECT * FROM PRODUTO;

SELECT * FROM REPRESENTANTE;

SELECT * FROM RESUMO_MENSAL_VENDA;

DECLARE
vMeta NUMBER :=0;
vRealizado NUMBER :=10000;
vPercentual NUMBER :=0;
BEGIN
-- Recuperar meta do vendedor para o mês corrente
SELECT r.rep_vl_metamensal
INTO vMeta
FROM representante r
WHERE r.rep_in_codigo = 10;
/* Só acha percentual se meta for maior que zero
para não gerar erro de divisão por zero
*/
IF vMeta > 0 THEN
vPercentual := (vRealizado / vMeta) * 100;
vPercentual := (vRealizado / vMeta) / 0; -- causa o erro de divisao por zero
dbms_output.put_line('O representante já realizou '||to_char(vPercentual)||
' de sua meta.'
);
ELSE
vPercentual := 0;
dbms_output.put_line('O representante não possui meta.');
END IF;
EXCEPTION
    WHEN zero_divide THEN
      DBMS_OUTPUT.put_line('ERRO COM SUCESSO!');
    WHEN not_logged_on THEN
      DBMS_OUTPUT.put_line('NAO LOGADO!');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('ERRO COM ERRO!');
END;
/



DECLARE
-- Declaração de variáveis
vCodeError NUMBER := 0;
vMessageError VARCHAR2(255) :='';
-- Declarar exceção
eRegistroInexistente exception;
BEGIN
-- Excluir cliente
DELETE cliente c
WHERE c.cli_in_codigo = 1000;
-- Se cliente não existe, gerar exceção
IF SQL%NOTFOUND THEN
raise eRegistroInexistente;
END IF;
-- Validar exclusão
COMMIT;
EXCEPTION
-- Se registro não existe, informa usuário
WHEN eRegistroInexistente THEN
ROLLBACK;
dbms_output.put_line('Cliente 1000 não existe!'||chr(10)||
'Nenhum registro foi excluído.'
);
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


DECLARE
-- Declarar exceção
eRegistroInexistente exception;
BEGIN
-- Excluir cliente
DELETE cliente c
WHERE c.cli_in_codigo = 1000;
-- Se cliente não existe, gerar exceção
IF SQL%NOTFOUND THEN
raise eRegistroInexistente;
END IF;
-- Validar exclusão
COMMIT;
EXCEPTION
-- Se registro não existe, informa usuário
WHEN eRegistroInexistente THEN
ROLLBACK;
raise_application_error(-20100,'Cliente 1000 não existe!'||chr(10)||
'Nenhum registro foi excluído.'
);
WHEN OTHERS THEN
ROLLBACK;
raise_application_error(-20101,'Ocorreu um erro não identificado'||chr(10)||
'ao tentar excluir o cliente 1000.');
END;
/


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
   WHERE CLIENTE.CLI_IN_CODIGO IN(10);
   
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


----- CAP 2


DECLARE
   vCliente CLIENTE%ROWTYPE;
   vCodeError NUMBER;
   vMessageError VARCHAR2(50);
   vContador NUMBER := 10;
BEGIN
   LOOP
     SELECT * INTO vCliente FROM CLIENTE
     WHERE CLIENTE.CLI_IN_CODIGO IN(vContador);
        
     dbms_output.put_line('------ CLIENTE ------'||chr(10)||
                          'Codigo: ' || vCliente.CLI_IN_CODIGO||chr(10)||
                          'Nome: ' || vCliente.CLI_ST_NOME||chr(10)||
                          'Endereço: ' || vCliente.CLI_ST_ENDERECO||chr(10)||
                          'Ramo Atividade: '|| vCliente.CLI_ST_RAMOATIVIDADE);
     vContador := vContador + 10;
     IF vCliente.CLI_IN_CODIGO >= 100 THEN
       EXIT;
     END IF;
   END LOOP;                     
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

BEGIN
FOR LoopCount IN 1..5 LOOP
dbms_output.put_line('Loop '|| to_char(LoopCount));
END LOOP;
END;
/



DECLARE
CURSOR cs_representante IS
SELECT r.rep_in_codigo, r.rep_st_nome
FROM representante r;
CURSOR cs_notafiscal IS
SELECT *
FROM nota_fiscal_venda;
BEGIN
NULL;
END;
/

DECLARE
  -- Declaração de variáveis
  vCodigoRep representante.rep_in_codigo%type;
  vNomeRep representante.rep_st_nome%type;
  -- Declaração de cursores
  CURSOR cs_representante is
  SELECT rep_in_codigo, rep_st_nome
FROM representante;
BEGIN
  -- Abre cursor
  OPEN cs_representante;
  -- Executa um loop com 10 ciclos
  FOR i IN 1..10 LOOP
    -- Extrai dados o registro corrente do cursor e avança para o próximo
    FETCH cs_representante INTO vCodigoRep , vNomeRep;
    -- Imprime dados extraídos na tela
    dbms_output.put_line(vCodigoRep||' - '||vNomeRep);
  END LOOP;
  close cs_representante;
END;
/

DECLARE
-- Declaração de cursores
CURSOR cs_representante is
SELECT rep_in_codigo, rep_st_nome
FROM representante;
-- Declaração de variáveis
rRep cs_representante%ROWTYPE;
BEGIN
-- Abre cursor se ainda não estiver aberto
IF NOT cs_representante%ISOPEN THEN
OPEN cs_representante;
END IF;
-- Executa um loop com 10 ciclos
LOOP
-- Extrai dados o registro corrente do cursor e avança para o próximo
FETCH cs_representante INTO rRep;
-- Sai do Loop quando não houver mais registros para processar
EXIT WHEN cs_representante%NOTFOUND;
-- Imprime dados extraídos na tela
dbms_output.put_line(rRep.rep_in_codigo||' - '||rRep.rep_st_nome);
END LOOP;
-- Fechar cursor
CLOSE cs_representante;
END;
/


DECLARE
-- Declaração de cursores
CURSOR cs_representante is
SELECT rep_in_codigo, rep_st_nome
FROM representante;
BEGIN
-- Inicia o loop no conjunto ativo do cursor
FOR rRep in cs_Representante LOOP
-- Imprime dados extraídos na tela
dbms_output.put_line(rRep.rep_in_codigo||' -- '||rRep.rep_st_nome);
END LOOP;
END;





DECLARE
-- Declaração de cursores
CURSOR cs_representante(pMenorMedia NUMBER, pMaiorMedia NUMBER) is
SELECT rep_in_codigo, rep_st_nome
FROM representante
WHERE rep_vl_mediamensalvendas BETWEEN pMenorMedia AND pMaiorMedia;
BEGIN
-- Abre cursor para representantes com média entre 40000 e 80000
dbms_output.put_line('Representantes com média entre 40000 e 80000');
FOR rRep in cs_Representante(40000,80000) LOOP
/* Imprime na tela os vendedores cuja média de vendas mensal
Está no intervalo de 40000 e 80000
*/
dbms_output.put_line(rRep.rep_in_codigo||' - '||rRep.rep_st_nome);
END LOOP;
-- Abre cursor para representantes com média entre 0 e 40000
dbms_output.put_line('Representantes com média entre 0 e 40000');
FOR rRep in cs_Representante(0,40000) LOOP
/* Imprime na tela os vendedores cuja média de vendas mensal
Está no intervalo de 80001 e 100000
*/
dbms_output.put_line(rRep.rep_in_codigo||' - '||rRep.rep_st_nome);
END LOOP;
END; 
/

DECLARE
vCODIGO CLIENTE.CLI_IN_CODIGO%TYPE;
BEGIN
  SELECT CLI_IN_CODIGO INTO vCODIGO FROM CLIENTE
  WHERE CLI_IN_CODIGO = 10;
    DBMS_OUTPUT.put_line(SQL%ROWCOUNT);
     
EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.put_line('ERRO');
END;

-----
DECLARE
  -- Declarar exceção
  eRegistroInexistente exception;
BEGIN
  -- Excluir cliente
  DELETE cliente c
  WHERE c.cli_in_codigo = 1000;
  -- Se cliente não existe, gerar exceção
  IF SQL%NOTFOUND THEN
     raise eRegistroInexistente;
  END IF;
  -- Validar exclusão
COMMIT;
EXCEPTION
  -- Se registro não existe, informa usuário
  WHEN eRegistroInexistente THEN
       ROLLBACK;
       dbms_output.put_line('Cliente 1000 não existe!'||chr(10)||
       'Nenhum registro foi excluído.'
       );
END;
/

-----





-----

SELECT * FROM REPRESENTANTE;
INSERT INTO REPRESENTANTE 
       VALUES ('Bruxa do 71', 12000, 60, 100000, '17/03/2016', 12000); 
       
