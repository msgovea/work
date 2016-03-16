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



