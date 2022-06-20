/* --------------------------------------------------------------------------- */
/* CRIANDO BANCO DE DADOS E USUÁRIO ADMINISTRADOR                              */
/* --------------------------------------------------------------------------- */

-- CRIANDO USUÁRIO adm
CREATE ROLE administrator WITH
  LOGIN
  SUPERUSER
  INHERIT
  CREATEDB
  CREATEROLE
  NOREPLICATION
  PASSWORD 'syslogadm'
;
COMMENT ON ROLE administrator IS 'Usuário administrador com os privilégios de criar, alterar e apagar o banco de dados e seus usuários.';

-- CRIANDO O BANCO DE DADOS university TENDO COMO OWNER O USUÁRIO adm
-- CONFIGURAÇÕES DE COLLATE E CTYPE SÃO PARA DEFINIRMOS A LÍNGUA PORTUGUESA COMO PADRÃO DO BANCO

CREATE DATABASE university WITH
  OWNER      = administrator
  TEMPLATE   = template0
  ENCODING   = 'UTF8'
  LC_COLLATE = 'pt_BR.UTF8'
  LC_CTYPE   = 'pt_BR.UTF8'
;
COMMENT ON DATABASE university IS 'Banco de dados para o pset3'

/* --------------------------------------------------------------------------- */
/* CONEXÃO AO BANCO university E CRIAÇÃO DO SCHEMA academic_system:            */
/* --------------------------------------------------------------------------- */


/* !!!!!!


O \connect NÃO ESTÁ FUNCIONANDO!!!! QUEM FOR TERMINAR O SCRIPT TENTA DAR UMA OLHADA NISSO, O RESTO DAS TABELAS E RELACIONAMENTOS TAO SENDO CRIADOS CERTINHO
  (comentário de nelio junior pra equipe)

 !!!!!! */


-- \connect "dbname=university user=administrator password=syslogadm"


CREATE SCHEMA IF NOT EXISTS academic_system AUTHORIZATION administrator;

-- Configura o SEARCH_PATH do usuário adm.
ALTER USER administrator SET SEARCH_PATH TO academic_system, "$user", public;

/* --------------------------------------------------------------------------- */
/* CRIANDO TABELAS E RELACIONAMENTOS PARA O SISTEMA ACADÊMICO                  */
/* --------------------------------------------------------------------------- */

CREATE TABLE academic_system.endereco (
                cep NUMERIC(10) NOT NULL,
                uf VARCHAR(2) NOT NULL,
                cidade CHAR(25) NOT NULL,
                bairro CHAR NOT NULL,
                complemento VARCHAR(100),
                numero NUMERIC(7) NOT NULL,
                logradouro CHAR(25) NOT NULL,
                CONSTRAINT pk_endereco PRIMARY KEY (cep)
);


CREATE TABLE academic_system.obras (
                codigo_obra VARCHAR NOT NULL,
                editora VARCHAR NOT NULL,
                tipo VARCHAR NOT NULL,
                nome VARCHAR NOT NULL,
                nome_autor VARCHAR NOT NULL,
                CONSTRAINT obras_pk PRIMARY KEY (codigo_obra)
);
COMMENT ON TABLE academic_system.obras IS 'Tabela obras. Guarda o nome do autor, o tipo de obra (CD,DVD,REVISTA,LIVRO), nome da obram, nome da editora, e o codigo da obra.';


CREATE TABLE academic_system.nome_autor (
                codigo_obra VARCHAR NOT NULL,
                nome_autor VARCHAR(200) NOT NULL,
                CONSTRAINT pk_nome_autor PRIMARY KEY (codigo_obra)
);
COMMENT ON TABLE academic_system.nome_autor IS 'Tabela criada para armazenar o atributo multivalorado "nome_autor" da tabela "obras".';


CREATE TABLE academic_system.volumes (
                codigo_obra VARCHAR NOT NULL,
                codigo_volume VARCHAR NOT NULL,
                CONSTRAINT volumes_pk PRIMARY KEY (codigo_obra, codigo_volume)
);
COMMENT ON TABLE academic_system.volumes IS 'Tabela que armazena os volumes das obras disponíveis no momento, com seus respectiovs códigos, ano de publicação e edição.';


CREATE TABLE academic_system.pessoas (
                cpf_pessoa VARCHAR NOT NULL,
                telefone NUMERIC(12) NOT NULL,
                nome_completo CHAR(25) NOT NULL,
                email VARCHAR(70) NOT NULL,
                data_de_cadastro DATE NOT NULL,
                cep NUMERIC(10) NOT NULL,
                CONSTRAINT pessoas_pk PRIMARY KEY (cpf_pessoa)
);
COMMENT ON TABLE academic_system.pessoas IS 'Tabela que armazena as informações chaves das pessoas que utilizam o sistea acadêmico.';
COMMENT ON COLUMN academic_system.pessoas.cpf_pessoa IS 'Primary Key da tabela. Armazena a informação essencial para identificar a pessoa no sistema.';
COMMENT ON COLUMN academic_system.pessoas.telefone IS 'Numero de telefone da pessoa referida.';
COMMENT ON COLUMN academic_system.pessoas.nome_completo IS 'Nome completo da pessoa referida.';
COMMENT ON COLUMN academic_system.pessoas.data_de_cadastro IS 'Data em que a pessoa foi cadastrada no sistema.';


CREATE TABLE academic_system.telefone (
                cpf_pessoa VARCHAR NOT NULL,
                telefone VARCHAR(15) NOT NULL,
                CONSTRAINT pk_telefone PRIMARY KEY (cpf_pessoa, telefone)
);
COMMENT ON TABLE academic_system.telefone IS 'Tabela criada para armazenar o atributo multivalorado "telefone" da tabela "pessoas"';

CREATE TABLE academic_system.reservas (
                cpf_pessoa VARCHAR NOT NULL,
                data_inicio_reserva VARCHAR NOT NULL,
                codigo_obra VARCHAR NOT NULL,
                codigo_volume VARCHAR NOT NULL,
                CONSTRAINT reservas_pk PRIMARY KEY (cpf_pessoa, data_inicio_reserva)
);
COMMENT ON TABLE academic_system.reservas IS 'Tabela que armazena quando uma obra foi reservada e quando a reserva terminou';


CREATE TABLE academic_system.emprestimos (
                data_inicio_emprestimo VARCHAR NOT NULL,
                cpf_pessoa VARCHAR NOT NULL,
                codigo_volume VARCHAR NOT NULL,
                codigo_obra VARCHAR NOT NULL,
                CONSTRAINT emprestimos_pk PRIMARY KEY (data_inicio_emprestimo, cpf_pessoa)
);
COMMENT ON TABLE academic_system.emprestimos IS 'Tabela que armazena quando uma obra foi emprestada e quando foi devolvida';


CREATE TABLE academic_system.professores (
                cpf_pessoa VARCHAR NOT NULL,
                graduacao VARCHAR(100) NOT NULL,
                pos_graduacao VARCHAR(100) NOT NULL,
                CONSTRAINT professores_pk PRIMARY KEY (cpf_pessoa)
);
COMMENT ON TABLE academic_system.professores IS 'Tabela que armazena informações de formação acadêmica dos professores';


CREATE TABLE academic_system.pos_graduacao (
                cpf_pessoa VARCHAR NOT NULL,
                pos_graduacao VARCHAR(30) NOT NULL,
                CONSTRAINT pk_pos_graduacao PRIMARY KEY (cpf_pessoa)
);
COMMENT ON TABLE academic_system.pos_graduacao IS 'Tabela criada para armazenar o atributo multivalorado "pos_graduacao" da tabela "professores"';


CREATE TABLE academic_system.graduacao (
                cpf_pessoa VARCHAR NOT NULL,
                graduacao VARCHAR(30) NOT NULL,
                CONSTRAINT pk_graduacao PRIMARY KEY (cpf_pessoa)
);
COMMENT ON TABLE academic_system.graduacao IS 'Tabela criada para armazenar o atributo multivalorado "graduacao" da tabela "professores"';


CREATE TABLE academic_system.alunos (
                cpf_pessoa VARCHAR NOT NULL,
                matricula NUMERIC(15) NOT NULL,
                CONSTRAINT alunos_pk PRIMARY KEY (cpf_pessoa)
);
COMMENT ON TABLE academic_system.alunos IS 'Tabela que armazena alunos matriculados no sistema acadêmico';


CREATE TABLE academic_system.ofertas (
                codigo_da_oferta VARCHAR(50) NOT NULL,
                cpf_pessoa VARCHAR NOT NULL,
                semestre NUMERIC(3) NOT NULL,
                quantidade_minima_de_alunos NUMERIC(10) NOT NULL,
                quantidade_maxima_de_alunos NUMERIC(50) NOT NULL,
                CONSTRAINT pk_ofertas PRIMARY KEY (codigo_da_oferta, cpf_pessoa)
);
COMMENT ON TABLE academic_system.ofertas IS 'Tabela que armazena ofertas de disciplinas para os alunos do sistema acadêmico';
COMMENT ON COLUMN academic_system.ofertas.codigo_da_oferta IS 'Codigo da Oferta';
COMMENT ON COLUMN academic_system.ofertas.cpf_pessoa IS 'Cpf da pessoa - Chave primaria';


CREATE TABLE academic_system.matriculam_se_em (
                cpf_pessoa VARCHAR NOT NULL,
                codigo_da_oferta VARCHAR(50) NOT NULL,
                CONSTRAINT pk_matriculam_se_em PRIMARY KEY (cpf_pessoa, codigo_da_oferta)
);
COMMENT ON TABLE academic_system.matriculam_se_em IS 'Tabela de relacionamento criada entre a tabela alunos e ofertas.';
COMMENT ON COLUMN academic_system.matriculam_se_em.cpf_pessoa IS 'Cpf da pessoa - Chave primaria';
COMMENT ON COLUMN academic_system.matriculam_se_em.codigo_da_oferta IS 'Codigo da Oferta';


CREATE TABLE academic_system.disciplinas (
                codigoDisciplina CHAR(4) NOT NULL,
                nome VARCHAR(50) NOT NULL,
                cargaHoraria TIME NOT NULL,
                ementa VARCHAR(200) NOT NULL,
                conteudo VARCHAR(200) NOT NULL,
                codigo_obra VARCHAR NOT NULL,
                CONSTRAINT disciplinas_pk PRIMARY KEY (codigoDisciplina)
);
COMMENT ON TABLE academic_system.disciplinas IS 'Tabela que armazena as disciplinas que compõem os cursos da instituição';
COMMENT ON COLUMN academic_system.disciplinas.codigoDisciplina IS 'Chave primária da Tabela disciplinas. É um codigo numérico que identifica uma disciplina de um curso da instituição';
COMMENT ON COLUMN academic_system.disciplinas.nome IS 'Atributo que armazena o nome da disciplina.';
COMMENT ON COLUMN academic_system.disciplinas.cargaHoraria IS 'Campo que armazena a carga horária da Disciplina em horas.';
COMMENT ON COLUMN academic_system.disciplinas.ementa IS 'Campo que descreve a ementa do curso';
COMMENT ON COLUMN academic_system.disciplinas.conteudo IS 'Atributo que armazena as informações do conteúdo de uma disciplina';


CREATE TABLE academic_system.envolvem (
                codigo_da_oferta VARCHAR(50) NOT NULL,
                cpf_pessoa VARCHAR NOT NULL,
                codigoDisciplina CHAR(4) NOT NULL,
                CONSTRAINT pk_envolvem PRIMARY KEY (codigo_da_oferta, cpf_pessoa, codigoDisciplina)
);
COMMENT ON TABLE academic_system.envolvem IS 'Tabela de relacionamento criada entre a tabela ofertas e disciplinas.';
COMMENT ON COLUMN academic_system.envolvem.cpf_pessoa IS 'Cpf da pessoa - Chave primaria';
COMMENT ON COLUMN academic_system.envolvem.codigoDisciplina IS 'Chave primária da Tabela disciplinas. É um codigo numérico que identifica uma disciplina de um curso da instituição';


CREATE TABLE academic_system.cursos (
                codigoCurso CHAR(3) NOT NULL,
                nome VARCHAR(50) NOT NULL,
                dataInicio DATE NOT NULL,
                CONSTRAINT cursos_pk PRIMARY KEY (codigoCurso)
);
COMMENT ON TABLE academic_system.cursos IS 'Tabela que armazena informações sobre os cursos da instituição';
COMMENT ON COLUMN academic_system.cursos.codigoCurso IS 'Chave primária da Tabela cursos. É um codigo numérico para identificar um curso específico';
COMMENT ON COLUMN academic_system.cursos.nome IS 'Atributo que armazena o nome oficial do curso';
COMMENT ON COLUMN academic_system.cursos.dataInicio IS 'Data em que o curso foi iniciado.';


CREATE TABLE academic_system.fazem (
                codigoCurso CHAR(3) NOT NULL,
                cpf_pessoa VARCHAR NOT NULL,
                CONSTRAINT fazem_pk PRIMARY KEY (codigoCurso, cpf_pessoa)
);
COMMENT ON TABLE academic_system.fazem IS 'Tabela de relacionamento entre a tabela alunos e cursos';
COMMENT ON COLUMN academic_system.fazem.codigoCurso IS 'Chave primária da Tabela cursos. É um codigo numérico para identificar um curso específico';
COMMENT ON COLUMN academic_system.fazem.cpf_pessoa IS 'Cpf da pessoa - Chave primaria';


CREATE TABLE academic_system.compoem (
                codigoDisciplina CHAR(4) NOT NULL,
                codigoCurso CHAR(3) NOT NULL,
                CONSTRAINT compoem_pk PRIMARY KEY (codigoDisciplina, codigoCurso)
);
COMMENT ON TABLE academic_system.compoem IS 'Tabela de relacionamento entre a tabelas disciplias e cursos';
COMMENT ON COLUMN academic_system.compoem.codigoDisciplina IS 'Chave primária da Tabela disciplinas. É um codigo numérico que identifica uma disciplina de um curso da instituição';
COMMENT ON COLUMN academic_system.compoem.codigoCurso IS 'Chave primária da Tabela cursos. É um codigo numérico para identificar um curso específico';


ALTER TABLE academic_system.pessoas ADD CONSTRAINT endereco_pessoas_fk
FOREIGN KEY (cep)
REFERENCES academic_system.endereco (cep)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE academic_system.volumes ADD CONSTRAINT obras_volumes_fk
FOREIGN KEY (codigo_obra)
REFERENCES academic_system.obras (codigo_obra)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE academic_system.disciplinas ADD CONSTRAINT obras_disciplinas_fk
FOREIGN KEY (codigo_obra)
REFERENCES academic_system.obras (codigo_obra)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE academic_system.nome_autor ADD CONSTRAINT obras_nome_autor_fk
FOREIGN KEY (codigo_obra)
REFERENCES academic_system.obras (codigo_obra)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE academic_system.emprestimos ADD CONSTRAINT volumes_emprestimos_fk
FOREIGN KEY (codigo_volume, codigo_obra)
REFERENCES academic_system.volumes (codigo_volume, codigo_obra)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE academic_system.reservas ADD CONSTRAINT volumes_reservas_fk
FOREIGN KEY (codigo_obra, codigo_volume)
REFERENCES academic_system.volumes (codigo_obra, codigo_volume)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE academic_system.alunos ADD CONSTRAINT pessoas_alunos_fk
FOREIGN KEY (cpf_pessoa)
REFERENCES academic_system.pessoas (cpf_pessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE academic_system.professores ADD CONSTRAINT pessoas_professores_fk
FOREIGN KEY (cpf_pessoa)
REFERENCES academic_system.pessoas (cpf_pessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE academic_system.emprestimos ADD CONSTRAINT pessoas_emprestimos_fk
FOREIGN KEY (cpf_pessoa)
REFERENCES academic_system.pessoas (cpf_pessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE academic_system.reservas ADD CONSTRAINT pessoas_reservas_fk
FOREIGN KEY (cpf_pessoa)
REFERENCES academic_system.pessoas (cpf_pessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE academic_system.telefone ADD CONSTRAINT pessoas_telefone_fk
FOREIGN KEY (cpf_pessoa)
REFERENCES academic_system.pessoas (cpf_pessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE academic_system.ofertas ADD CONSTRAINT professores_ofertas_fk
FOREIGN KEY (cpf_pessoa)
REFERENCES academic_system.professores (cpf_pessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE academic_system.graduacao ADD CONSTRAINT professores_graduacao_fk
FOREIGN KEY (cpf_pessoa)
REFERENCES academic_system.professores (cpf_pessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE academic_system.pos_graduacao ADD CONSTRAINT professores_pos_graduacao_fk
FOREIGN KEY (cpf_pessoa)
REFERENCES academic_system.professores (cpf_pessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE academic_system.ofertas ADD CONSTRAINT alunos_ofertas_fk
FOREIGN KEY (cpf_pessoa)
REFERENCES academic_system.alunos (cpf_pessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE academic_system.fazem ADD CONSTRAINT alunos_fazem_fk
FOREIGN KEY (cpf_pessoa)
REFERENCES academic_system.alunos (cpf_pessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE academic_system.matriculam_se_em ADD CONSTRAINT alunos_matriculam_se_em_fk
FOREIGN KEY (cpf_pessoa)
REFERENCES academic_system.alunos (cpf_pessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE academic_system.envolvem ADD CONSTRAINT ofertas_envolvem_fk
FOREIGN KEY (cpf_pessoa, codigo_da_oferta)
REFERENCES academic_system.ofertas (cpf_pessoa, codigo_da_oferta)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE academic_system.matriculam_se_em ADD CONSTRAINT ofertas_matriculam_se_em_fk
FOREIGN KEY (cpf_pessoa, codigo_da_oferta)
REFERENCES academic_system.ofertas (cpf_pessoa, codigo_da_oferta)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE academic_system.compoem ADD CONSTRAINT disciplinas_compoe_fk
FOREIGN KEY (codigoDisciplina)
REFERENCES academic_system.disciplinas (codigoDisciplina)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE academic_system.envolvem ADD CONSTRAINT disciplinas_envolvem_fk
FOREIGN KEY (codigoDisciplina)
REFERENCES academic_system.disciplinas (codigoDisciplina)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE academic_system.compoem ADD CONSTRAINT cursos_compoe_fk
FOREIGN KEY (codigoCurso)
REFERENCES academic_system.cursos (codigoCurso)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE academic_system.fazem ADD CONSTRAINT cursos_fazem_fk
FOREIGN KEY (codigoCurso)
REFERENCES academic_system.cursos (codigoCurso)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;