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
    veiculo varchar(100),
	descricao varchar(256) not null,
	fk_status_agendamento int not null,
    hora_retirada time,
	observacao varchar(256),
	foreign key (fk_usuario) references usuario(id),
	foreign key (fk_status_agendamento) references status_agendamento(id)
);

create table servico_agendado (
	id int primary key auto_increment,
	fk_agendamento int,
	fk_servico int,
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
insert into veiculo (fk_usuario, placa, marca, modelo, ano, km) values
(1, 'ABC1234', 'Honda', 'CB500X', 2022, 12300),
(2, 'REG5678', 'Yamaha', 'Factor 150', 2020, 21500),
(3, 'CAR9012', 'Honda', 'CG 160', 2021, 14700);

-- agendamento
insert into agendamento (fk_usuario, data, hora, veiculo, descricao, fk_status_agendamento, hora_retirada, observacao) values
(1, '2025-10-10', '14:00:00', 'Honda CB500X - ABC1234', 'Revisão geral para viagem', 1, '16:00:00', null),
(1, '2025-10-15', '09:30:00', 'Honda CB500X - ABC1234', 'Troca de óleo antes da viagem', 2, '14:00:00', 'Cliente com pressa'),
(2, '2025-10-12', '11:00:00', 'Yamaha Factor 150 - REG5678', 'Revisão de freios', 1, '17:00:00', null),
(3, '2025-10-18', '15:00:00', 'Honda CG 160 - CAR9012', 'Revisão periódica 10.000km', 3, '17:00:00', 'Serviço finalizado sem observações'),
(1, '2025-10-20', '10:00:00', 'Honda CB500X - ABC1234', 'Troca de filtros', 4, null, 'Cliente cancelou via telefone'),
(2, '2025-10-25', '14:30:00', 'Yamaha Factor 150 - REG5678', 'Revisão completa antes de viagem longa', 2, '14:00:00', 'Cliente solicitou troca de óleo e revisão geral'),
(3, '2025-09-28', '08:45:00', 'Honda CG 160 - CAR9012', 'Verificação elétrica e manutenção corretiva', 1, '15:00:00', 'Possível falha no sistema de ignição');

-- servico_agendado (vincular 2 serviços ao agendamento)
insert into servico_agendado (fk_agendamento, fk_servico) values
(1, 1), -- Troca de óleo
(1, 3), -- Reparo nos freios
(2, 1), -- Troca de óleo
(3, 3), -- Reparo nos freios
(4, 4), -- Revisão periódica
(5, 2), -- Revisão de filtros
(6, 1),  -- Troca de Óleo
(6, 4),  -- Revisão Periódica
(7, 2),  -- Revisão de Filtros
(7, 3);  -- Reparo no Freio

-- ---------- FIM DO SCRIPT DE POPULAÇÃO DE DADOS (INSERTS) ---------- --

-- ---------- INÍCIO DOS SCRIPTS DE CONSULTAS E VIEWS (SELECTS) ---------- --

select * from agendamento;
select * from usuario;
select * from endereco;
select * from servico_agendado;
select * from veiculo;

create view vw_agendamentos_clientes AS
select
    a.id as id_agendamento,
    a.fk_usuario as id_usuario,
    CONCAT(u.nome, ' ', u.sobrenome) as nome_cliente,
    a.veiculo as nome_veiculo,
    a.data as data_agendamento,
    TIME_FORMAT(a.hora, '%H:%i:%s') as hora_agendamento,
    TIME_FORMAT(a.hora_retirada, '%H:%i:%s') as hora_retirada,
    sa.status as status,
    a.descricao,
    a.observacao,
    GROUP_CONCAT(s.nome SEPARATOR ', ') as servicos
FROM agendamento a
JOIN usuario u ON u.id = a.fk_usuario
JOIN status_agendamento sa ON sa.id = a.fk_status_agendamento
LEFT JOIN servico_agendado sag ON sag.fk_agendamento = a.id
LEFT JOIN servico s ON s.id = sag.fk_servico
GROUP BY
    a.id,
    a.fk_usuario,
    u.nome,
    u.sobrenome,
    a.veiculo,
    a.data,
    a.hora,
    a.hora_retirada,
    sa.status,
    a.descricao;

select * from vw_agendamentos_clientes;

create or replace view vw_veiculos_clientes as
select
    v.id as id_veiculo,
    v.fk_usuario as id_usuario,
    concat(v.marca, ' ', v.modelo, ' - ', v.placa) as descricao_veiculo,
    v.km
from veiculo v
order by v.fk_usuario, v.marca, v.modelo;

select * from vw_veiculos_clientes where id_usuario = 1;

create or replace view vw_servicos_resumidos as
select 
    s.id as id_servico,
    s.nome as nome_servico
from servico s;

select * from vw_servicos_resumidos;

create or replace view vw_perfil_usuario as
select
    u.id as id_usuario,
    concat(u.nome, ' ', u.sobrenome) as nome_completo,
    u.email,
    u.telefone,
    
    -- contagem de agendamentos pendentes e concluídos
    (
        select count(*)
        from agendamento a
        join status_agendamento sa on sa.id = a.fk_status_agendamento
        where a.fk_usuario = u.id and sa.status = 'Pendente'
    ) as qtd_pendentes,

    (
        select count(*)
        from agendamento a
        join status_agendamento sa on sa.id = a.fk_status_agendamento
        where a.fk_usuario = u.id and sa.status = 'Concluído'
    ) as qtd_concluidos

from usuario u
left join veiculo v on v.fk_usuario = u.id
group by
    u.id,
    v.id,
    u.nome,
    u.sobrenome,
    u.email,
    u.telefone;

select * from vw_perfil_usuario where id_usuario = 1;

create or replace view vw_veiculos_perfil as
select
    v.id id_veiculo,
    v.fk_usuario id_usuario,
    v.marca,
    v.modelo,
    v.ano,
    v.km,
    v.placa
from veiculo v;

select * from vw_veiculos_perfil where id_usuario = 1;