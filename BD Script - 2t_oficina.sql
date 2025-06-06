-- CONFIGURAÇÕES DO BANCO DE DADOS --
create database 2t_oficina;
use 2t_oficina;
-- drop database 2t_oficina;

-- ---------- INÍCIO DO SCRIPT DE CRIAÇÃO DE TABELAS ---------- --

create table tipo_usuario (
	id int auto_increment primary key,
	tipo varchar(45) not null
);

create table logradouro (
	id int auto_increment primary key,
	tipo varchar(25) not null
);

create table status_agendamento (
	id int auto_increment primary key,
	status varchar(45) not null
);

create table usuario (
	id int auto_increment primary key,
	fk_tipo_usuario int not null,
	nome varchar(45) not null,
	sobrenome varchar(45) not null,
	telefone varchar(45) not null,
	email varchar(256) unique not null,
	senha varchar(128) not null,
	data_cadastro timestamp not null,
	sexo varchar(45) check (sexo in ('Masculino', 'Feminino', 'Outro', 'Prefiro não informar')),
	data_nasc date,
	foreign key (fk_tipo_usuario) references tipo_usuario(id)
);

create table endereco (
	id int auto_increment primary key,
    fk_usuario int not null,
	fk_logradouro int not null,
	nome_logradouro varchar(45) not null,
	numero_logradouro int not null,
	cidade varchar(60) not null,
	estado varchar(45) not null,
	bairro varchar(45) not null,
	cep char(8) not null,
	complemento varchar(25),
    foreign key (fk_usuario) references usuario(id),
	foreign key (fk_logradouro) references logradouro(id)
);

create table veiculo (
	id int primary key auto_increment,
	placa varchar(10) unique,
	fk_usuario int not null,
	marca varchar(45) not null,
	modelo varchar(45) not null,
	ano smallint not null,
	km double not null,
	foto blob,
	foreign key (fk_usuario) references usuario(id)
);

create table categoria_servico (
	id int auto_increment primary key,
	nome varchar(45) not null
);

create table servico (
	id int auto_increment primary key,
	fk_categoria_servico int not null,
	nome varchar(45) not null,
	descricao varchar(128) not null,
	eh_rapido tinyint default 0 not null,
	foreign key (fk_categoria_servico) references categoria_servico(id)
);

create table funcionamento (
	id int auto_increment primary key,
	dia_semana int not null, -- 0: Domingo, 1: Segunda, 2: Terça ...
	inicio_funcionamento time not null,
	fim_funcionamento time not null
);

create table excecao (
	id int auto_increment primary key,
	data_inicio date not null,
	data_fim date not null,
	inicio_excecao time not null,
    fim_excecao time not null
);

create table agendamento (
	id int auto_increment primary key,
	fk_usuario int not null,
    data date not null,
    hora time not null,
	descricao varchar(256) not null,
	fk_status_agendamento int not null,
    hora_retirada time,
	observacao varchar(256),
	foreign key (fk_usuario) references usuario(id),
	foreign key (fk_status_agendamento) references status_agendamento(id)
);

create table servico_agendado (
	fk_agendamento int,
	fk_servico int,
	primary key (fk_agendamento, fk_servico),
	foreign key (fk_agendamento) references agendamento(id),
	foreign key (fk_servico) references servico(id)
);

-- ---------- FIM DO SCRIPT DE CRIAÇÃO DE TABELAS ---------- --

-- ---------- INÍCIO DO SCRIPT DE POPULAÇÃO DE DADOS (INSERTS) ---------- --

-- tipo_usuario
insert into tipo_usuario (tipo) values
('Cliente'),
('Funcionário'),
('Administrador');

-- status_agendamento
insert into status_agendamento (status) values
('Pendente'),
('Em Atendimento'),
('Concluído'),
('Cancelado');

-- funcionamento
insert into funcionamento (dia_semana, inicio_funcionamento, fim_funcionamento) values
(1, '08:00:00','17:00:00'),
(2, '08:00:00', '17:00:00'),
(3, '08:00:00', '17:00:00'),
(4, '08:00:00', '17:00:00'),
(5, '08:00:00', '17:00:00'),
(6, '08:30:00', '12:00:00');

-- excecao
insert into excecao (data_inicio, data_fim, inicio_excecao, fim_excecao) values
('2025-06-12', '2025-06-13', '08:00:00', '13:00:00');

-- categoria_servico
insert into categoria_servico (nome) values
('Manutenção Preventiva'),
('Manutenção Corretiva'),
('Manutenção Periódica'),
('Revisão');

-- servico
insert into servico (fk_categoria_servico, nome, descricao, eh_rapido) values
(1, 'Troca de Óleo', 'Substituição do óleo do motor e verificação do nível', 1),
(1, 'Revisão de Filtros', 'Troca de filtro de ar, combustível e óleo', 0),
(2, 'Reparo no Freio', 'Diagnóstico e substituição do sistema de freios', 0),
(4, 'Revisão Periódica 10.000km', 'Revisão completa recomendada pelo fabricante', 0);

-- logradouro
insert into logradouro (tipo) values
('Rua'),
('Avenida'),
('Travessa'),
('Alameda');

-- usuario
insert into usuario (fk_tipo_usuario, nome, sobrenome, telefone, email, senha, data_cadastro, sexo, data_nasc) values
(1, 'João', 'Silva', '11938472651', 'joao.silva@gmail.com', 'senha123', current_timestamp, null, null),
(1, 'Regina', 'Castro', '11957843260', 'regina.castro@gmail.com', 'senha123', current_timestamp, 'Feminino', '1992-08-15'),
(1, 'Carlos', 'Oliveira', '11984716295', 'carlos.oliveira@gmail.com', 'senha123', current_timestamp, 'Masculino', '1985-02-27'),
(2, 'Diego', 'dos Santos', '11963574820', 'diego.2toficina@gmail.com', 'senha123', current_timestamp, 'Masculino', '2006-08-15'),
(3, 'Gianluca', 'Macedo', '11927036481', 'gian.2toficina@gmail.com', 'senha123', current_timestamp, 'Masculino', '2005-05-19');

-- endereco
insert into endereco (fk_usuario, fk_logradouro, nome_logradouro, numero_logradouro, cidade, estado, bairro, cep, complemento) values
(2, 1, 'das Flores', 123, 'São Paulo', 'SP', 'Centro', '01001000', 'Apto 101'),
(4, 2, 'Atlântica', 456, 'Rio de Janeiro', 'RJ', 'Copacabana', '22070000', 'Bloco B'),
(3, 2, 'Paulista', 1000, 'São Paulo', 'SP', 'Bela Vista', '01310000', null),
(1, 3, 'Independência', 45, 'Campinas', 'SP', 'Jardim Progresso', '13000000', 'Casa'),
(5, 1, 'Engenheiro Mesquita Sampaio', 1024, 'São Paulo', 'SP', 'Morumbi', '04711000', null);
-- (4, 'Alameda das Palmeiras', 78, 'Belo Horizonte', 'MG', 'Savassi', '30140071', null); Não descomentar.

-- veiculo
insert into veiculo (placa, fk_usuario, marca, modelo, ano, km) values
('ABC1234', 1, 'Honda', 'CB500X', 2022, 12300),
('REG5678', 2, 'Yamaha', 'Factor 150', 2020, 21500),
('CAR9012', 3, 'Honda', 'CG 160', 2021, 14700);

-- agendamento
insert into agendamento (fk_usuario, data, hora, descricao, fk_status_agendamento, hora_retirada, observacao) values
(1, '2025-06-09', '14:00:00', 'Revisão geral para viagem', 1, null, null);

-- servico_agendado (vincular 2 serviços ao agendamento)
insert into servico_agendado (fk_agendamento, fk_servico) values
(1, 1), -- Manutenção Preventiva
(1, 3); -- Revisão

-- ---------- FIM DO SCRIPT DE POPULAÇÃO DE DADOS (INSERTS) ---------- --

-- ---------- INÍCIO DOS SCRIPTS DE CONSULTAS E VIEWS (SELECTS) ---------- --

-- Listar todos os usuários com tipo e endereço
create view vw_usuarios_completos as
select 
    u.id as id_usuario,
    u.nome,
    u.sobrenome,
    u.email,
    u.telefone,
    u.sexo,
    u.data_nasc,
    tu.tipo as tipo_usuario,
    e.cidade,
    e.estado,
    e.bairro,
    e.nome_logradouro,
    e.numero_logradouro,
    l.tipo as tipo_logradouro,
    e.cep,
    e.complemento
from usuario u
join tipo_usuario tu on u.fk_tipo_usuario = tu.id
left join endereco e on e.fk_usuario = u.id
left join logradouro l on e.fk_logradouro = l.id;

select * from vw_usuarios_completos;

-- Listar veículos de um usuário específico (ex: id = 1)
create view vw_veiculos_usuario_1 as
select 
    v.id as id_veiculo,
    v.placa,
    v.marca,
    v.modelo,
    v.ano,
    v.km,
    v.foto
from veiculo v
where v.fk_usuario = 1;

select * from vw_veiculos_usuario_1;

-- Agendamentos futuros de um usuário
create view vw_agendamentos_futuros as
select 
    a.id as id_agendamento,
    a.fk_usuario,
    u.nome,
    a.data,
    a.hora,
    a.hora_retirada,
    a.descricao,
    sa.status,
    a.observacao
from agendamento a
join usuario u on a.fk_usuario = u.id
join status_agendamento sa on a.fk_status_agendamento = sa.id
where a.data > current_date;

select * from vw_agendamentos_futuros;

-- Serviços de um agendamento
create view vw_servicos_por_agendamento as
select 
    sa.fk_agendamento,
    s.nome as nome_servico,
    s.descricao,
    cs.nome as categoria,
    s.eh_rapido
from servico_agendado sa
join servico s on sa.fk_servico = s.id
join categoria_servico cs on s.fk_categoria_servico = cs.id;

select * from vw_servicos_por_agendamento;