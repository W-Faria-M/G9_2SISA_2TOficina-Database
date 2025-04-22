-- CONFIGURAÇÕES DO BANCO DE DADOS --
create database 2t_oficina;
use 2t_oficina;
-- drop database 2t_oficina;

-- ---------- INÍCIO DO SCRIPT DE CRIAÇÃO DE TABELAS ---------- --

create table logradouro (
	id int auto_increment primary key,
	tipo varchar(25) not null
);

create table endereco (
	id int auto_increment primary key,
	fkLogradouro int not null,
	nome_logradouro varchar(45) not null,
	num_logradouro int not null,
	cidade varchar(60) not null,
	estado varchar(45) not null,
	bairro varchar(45) not null,
	cep char(8) not null,
	complemento varchar(25),
	foreign key (fkLogradouro) references logradouro(id)
);

create table tipo_usuario (
	id int auto_increment primary key,
	tipo varchar(45) not null
);

create table status_agendamento (
	id int auto_increment primary key,
	status varchar(45) not null
);

create table status_comanda (
	id int auto_increment primary key,
	status varchar(45) not null
);

create table usuario (
	id int auto_increment primary key,
	fkEndereco int,
	fkTipoUsuario int not null,
	nome varchar(45) not null,
	sobrenome varchar(45) not null,
	telefone varchar(45) not null,
	email varchar(256) unique not null,
	senha varchar(128) not null,
	data_cadastro timestamp not null,
	sexo varchar(45),
	data_nasc date,
	foreign key (fkEndereco) references endereco(id),
	foreign key (fkTipoUsuario) references tipo_usuario(id)
);

create table veiculo (
	placa varchar(10) primary key,
	fkUsuario int not null,
	marca varchar(45) not null,
	modelo varchar(45) not null,
	ano smallint not null,
	km double not null,
	foto blob,
	foreign key (fkUsuario) references usuario(id)
);

create table avaliacao (
	id int auto_increment primary key,
	fkUsuario int not null,
	titulo varchar(45) not null,
	mensagem varchar(128) not null,
	nota int not null,
	data_av timestamp not null,
	foreign key (fkUsuario) references usuario(id)
);

create table categoria_servico (
	id int auto_increment primary key,
	nome varchar(45) not null
);

create table servico (
	id int auto_increment primary key,
	fkCategoriaServico int not null,
	nome varchar(45) not null,
	descricao varchar(128) not null,
	eh_rapido tinyint default 0 not null,
	foreign key (fkCategoriaServico) references categoria_servico(id)
);

create table horario_padrao (
	id int auto_increment primary key,
	dia_semana int not null, -- 0: Domingo, 1: Segunda, 2: Terça ...
	hora_inicio time not null,
	hora_fim time not null
);

create table agenda_dia (
	id int auto_increment primary key,
	data date not null,
	fkHorarioPadrao int not null,
	disponivel tinyint default 0 not null,
	foreign key (fkHorarioPadrao) references horario_padrao(id)
);

create table agendamento (
	id int auto_increment primary key,
	fkAgendaDia int not null,
	fkUsuario int not null,
	descricao varchar(256) not null,
	fkStatus int not null,
	observacao varchar(256),
	foreign key (fkAgendaDia) references agenda_dia(id),
	foreign key (fkUsuario) references usuario(id),
	foreign key (fkStatus) references status_agendamento(id)
);

create table servico_agendado (
	fkAgendamento int,
	fkServico int,
	primary key (fkAgendamento, fkServico),
	foreign key (fkAgendamento) references agendamento(id),
	foreign key (fkServico) references servico(id)
);

create table comanda (
	id int auto_increment primary key,
	fkAgendamento int not null,
	fkVeiculo varchar(10) not null,
	data_comanda timestamp not null,
	fkStatus int not null,
	observacao varchar(256),
	foreign key (fkAgendamento) references agendamento(id),
	foreign key (fkVeiculo) references veiculo(placa),
	foreign key (fkStatus) references status_comanda(id)
);

create table categoria_item (
	id int auto_increment primary key,
	nome varchar(45) not null
);

create table item (
	id int auto_increment primary key,
	nome varchar(45) not null,
	eh_padrao tinyint default 0 not null,
	fkCategoriaItem int not null,
	foreign key (fkCategoriaItem) references categoria_item(id)
);

create table item_servico (
	id int,
	fkServico int,
	fkItem int,
	primary key (id, fkServico, fkItem),
	foreign key (fkServico) references servico(id),
	foreign key (fkItem) references item(id)
);

create table checklist (
	id int primary key auto_increment,
	fkComanda int,
	fkItem int,
	status tinyint default 0 not null,
	foreign key (fkComanda) references comanda(id),
	foreign key (fkItem) references item(id)
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

-- status_comanda
insert into status_comanda (status) values
('Aberta'),
('Em Andamento'),
('Finalizada');

-- horario_padrao
insert into horario_padrao (dia_semana, hora_inicio, hora_fim) values
(1, '08:00:00', '09:30:00'),
(1, '10:00:00', '11:30:00'),
(1, '13:30:00', '15:00:00'),
(1, '15:30:00', '17:00:00'),
(2, '08:00:00', '09:30:00'),
(2, '10:00:00', '11:30:00'),
(2, '13:30:00', '15:00:00'),
(2, '15:30:00', '17:00:00'),
(3, '08:00:00', '09:30:00'),
(3, '10:00:00', '11:30:00'),
(3, '13:30:00', '15:00:00'),
(3, '15:30:00', '17:00:00'),
(4, '08:00:00', '09:30:00'),
(4, '10:00:00', '11:30:00'),
(4, '13:30:00', '15:00:00'),
(4, '15:30:00', '17:00:00'),
(5, '08:00:00', '09:30:00'),
(5, '10:00:00', '11:30:00'),
(5, '13:30:00', '15:00:00'),
(5, '15:30:00', '17:00:00'),
(6, '08:30:00', '10:00:00'),
(6, '10:30:00', '12:00:00');

-- categoria_servico
insert into categoria_servico (nome) values
('Manutenção Preventiva'),
('Manutenção Corretiva'),
('Manutenção Periódica'),
('Revisão');

-- servico
insert into servico (fkCategoriaServico, nome, descricao, eh_rapido) values
(1, 'Troca de Óleo', 'Substituição do óleo do motor e verificação do nível', 1),
(1, 'Revisão de Filtros', 'Troca de filtro de ar, combustível e óleo', 0),
(2, 'Reparo no Freio', 'Diagnóstico e substituição do sistema de freios', 0),
(4, 'Revisão Periódica 10.000km', 'Revisão completa recomendada pelo fabricante', 0);

-- categoria_item
insert into categoria_item (nome) values
('Motor'),
('Freios'),
('Suspensão'),
('Elétrica'),
('Óleo e Filtros');

-- item
insert into item (nome, eh_padrao, fkCategoriaItem) values
('Verificar nível do óleo', 1, 5),
('Verificar pastilhas de freio', 1, 2),
('Verificar amortecedores', 1, 3),
('Verificar luzes do painel', 1, 4),
('Trocar óleo do motor', 0, 5),
('Substituir filtro de ar', 0, 5),
('Ajustar sistema de freio', 0, 2),
('Inspecionar velas de ignição', 0, 1);

-- logradouro
insert into logradouro (tipo) values
('Rua'),
('Avenida'),
('Travessa');

-- endereco
insert into endereco (fkLogradouro, nome_logradouro, num_logradouro, cidade, estado, bairro, cep, complemento) values
(1, 'das Flores', 123, 'São Paulo', 'SP', 'Centro', '01001000', 'Apto 101'),
(2, 'Paulista', 1000, 'São Paulo', 'SP', 'Bela Vista', '01310000', null),
(3, 'Independência', 45, 'Campinas', 'SP', 'Jardim Progresso', '13000000', 'Casa');

-- usuario
insert into usuario (fkEndereco, fkTipoUsuario, nome, sobrenome, telefone, email, senha, data_cadastro, sexo, data_nasc) values
(1, 1, 'João', 'Silva', '11999999999', 'joao.silva@gmail.com', 'senha123', current_timestamp, null, null),
(2, 2, 'Diego', 'dos Santos', '11988888888', 'diego@gmail.com', 'senha123', current_timestamp, 'Masculino', '2006-08-15'),
(3, 3, 'Gianluca', 'Macedo', '11977777777', 'gian@gmail.com', 'senha123', current_timestamp, 'Masculino', '2005-05-19');

-- veiculo
insert into veiculo (placa, fkUsuario, marca, modelo, ano, km) values
('ABC1234', 1, 'Honda', 'CB500X', 2022, 12300);

-- agenda_dia
insert into agenda_dia (data, fkHorarioPadrao, disponivel) values
('2025-04-25', 2, 1);

-- agendamento
insert into agendamento (fkAgendaDia, fkUsuario, descricao, fkStatus, observacao) values
(1, 1, 'Revisão geral para viagem', 1, null);

-- servico_agendado (vincular 2 serviços ao agendamento)
insert into servico_agendado (fkAgendamento, fkServico) values
(1, 1), -- Manutenção Preventiva
(1, 3); -- Revisão

-- comanda
insert into comanda (fkAgendamento, fkVeiculo, data_comanda, fkStatus, observacao) values
(1, 'ABC1234', current_timestamp, 1, null);

-- item_servico
insert into item_servico (id, fkServico, fkItem) values
(1, 1, 5), -- Manutenção Preventiva → Trocar óleo
(2, 1, 6), -- Manutenção Preventiva → Filtro de ar
(3, 3, 7), -- Revisão → Ajuste do freio
(4, 3, 8); -- Revisão → Velas de ignição

-- checklist
insert into checklist (fkComanda, fkItem, status) values
-- (itens padrão sempre incluídos)
(1, 1, 0), -- Verificar nível do óleo
(1, 2, 0), -- Verificar pastilhas de freio
(1, 3, 0), -- Verificar amortecedores
(1, 4, 0), -- Verificar luzes do painel
-- (itens específicos via item_servico dos serviços agendados)
(1, 5, 0), -- Trocar óleo do motor
(1, 6, 0), -- Substituir filtro de ar
(1, 7, 0), -- Ajustar sistema de freio
(1, 8, 0); -- Inspecionar velas de ignição

-- ---------- FIM DO SCRIPT DE POPULAÇÃO DE DADOS (INSERTS) ---------- --

-- ---------- INÍCIO DOS SCRIPTS DE CONSULTAS E VIEWS (SELECTS) ---------- --

-- Listar todos os usuários com tipo e endereço
select 
	u.id,
	u.nome,
	u.sobrenome,
	tu.tipo as tipo_usuario,
	e.nome_logradouro,
	e.num_logradouro,
	e.bairro,
	e.cidade,
	e.estado,
	e.cep
from usuario u
join tipo_usuario tu on u.fkTipoUsuario = tu.id
join endereco e on u.fkEndereco = e.id;

-- Listar veículos de um usuário específico (ex: id = 1)
select 
	v.placa,
	v.marca,
	v.modelo,
	v.ano,
	v.km
from veiculo v
where v.fkUsuario = 1;

-- Agendamentos futuros de um usuário
select 
	a.id,
	ad.data,
	ha.hora_inicio,
	ha.hora_fim,
	sa.status,
	a.descricao,
	a.observacao
from agendamento a
join agenda_dia ad on a.fkAgendaDia = ad.id
join horario_padrao ha on ad.fkHorarioPadrao = ha.id
join status_agendamento sa on a.fkStatus = sa.id
where a.fkUsuario = 1
  and ad.data >= curdate();

-- Serviços de um agendamento
  select 
	sa.fkServico,
	s.nome,
	s.descricao,
	s.eh_rapido
from servico_agendado sa
join servico s on sa.fkServico = s.id
where sa.fkAgendamento = 1;

-- Comandas com veículo, status e observação
select 
	c.id,
	c.data_comanda,
	c.fkVeiculo,
	sc.status as status_comanda,
	c.observacao
from comanda c
join status_comanda sc on c.fkStatus = sc.id;

-- Checklist de uma comanda
select 
	i.nome as item,
	ch.status
from checklist ch
join item i on ch.fkItem = i.id
where ch.fkComanda = 1;

-- Itens associados a um serviço
select 
	s.nome as servico,
	i.nome as item
from item_servico isv
join servico s on isv.fkServico = s.id
join item i on isv.fkItem = i.id
where s.id = 1;

-- Ver disponibilidade de horários para um dia específico
select 
	ad.data,
	hp.hora_inicio,
	hp.hora_fim,
	ad.disponivel
from agenda_dia ad
join horario_padrao hp on ad.fkHorarioPadrao = hp.id
where ad.data = '2025-04-25';