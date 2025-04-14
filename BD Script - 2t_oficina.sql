create database 2tOficina;
use 2tOficina;

create table logradouro (
	id int auto_increment primary key,
    tipo varchar(25) not null
	);

create table endereco (
	id int auto_increment primary key,
    fkLogradouro int not null,
    nome_logradouro varchar(45) not null,
    num_logradouro int,
    cidade varchar(60) not null,
    estado varchar(45) not null,
    bairro varchar(45) not null,
    cep char(8) not null,
    complemento varchar(25),
    foreign key (fkLogradouro) references logradouro(id)
	);

create table tipoUsuario (
	id int auto_increment primary key,
    tipo varchar(25) not null
	);

create table usuario (
    id int auto_increment primary key,
    fkEndereco int,
    fkTipoUsuario int,
    nome varchar(45) not null,
    telefone char(11),
    email varchar(256) unique not null,
    senha varchar(128) not null,
    dt_cadastro timestamp default current_timestamp,
    sexo varchar(45),
    dt_nasc date,
    foreign key (fkEndereco) references endereco(id),
    foreign key (fkTipoUsuario) references tipoUsuario(id)
	);

create table veiculo (
    id int auto_increment primary key,
    fkUsuario int,
    marca varchar(45) not null,
    modelo varchar(45) not null,
    ano varchar(4) not null,
    km double not null,
    placa varchar(45) unique not null,
    foreign key (fkUsuario) references usuario(id)
	);

create table avaliacao (
    id int auto_increment primary key,
    fkUsuario int,
    titulo varchar(45) not null,
    mensagem varchar(128) not null,
    nota int check (nota between 1 and 5),
    data_av timestamp default current_timestamp,
    foreign key (fkusuario) references usuario(id)
	);

create table categoriaServico (
	id int auto_increment primary key,
    nome varchar(25) not null
    );

create table servico (
    id int auto_increment primary key,
    fkCategoriaServico int,
    nome varchar(45) not null,
    descricao varchar(128),
    rapido tinyint default 0,
    foreign key (fkCategoriaServico) references categoriaServico(id)
	);

create table agendamento (
    id int auto_increment primary key,
    fkUsuario int,
    data_ag timestamp default current_timestamp,
    descricao varchar(128),
    status_ag varchar(45),
    observacao varchar(128),
    foreign key (fkUsuario) references usuario(id)
	);

create table servicoAgendado (
    fkAgendamento int,
    fkServico int,
    primary key (fkAgendamento, fkServico),
    foreign key (fkAgendamento) references agendamento(id),
    foreign key (fkServico) references servico(id)
	);

create table comanda (
    id int auto_increment primary key,
    fkVeiculo int,
    fkServico int,
    data_comanda timestamp default current_timestamp,
    observacao varchar(90),
    foreign key (fkVeiculo) references veiculo(id),
    foreign key (fkServico) references servico(id)
	);

create table categoriaItem (
    id int auto_increment primary key,
    nome varchar(45) not null
	);

create table item (
    id int auto_increment primary key,
    nome varchar(45) not null,
    fkCategoriaItem int,
    foreign key (fkCategoriaItem) references categoriaItem(id)
	);

create table checklist (
    fkComanda int,
    fkItem int,
    status tinyint default 0,
    primary key (fkComanda, fkItem),
    foreign key (fkComanda) references comanda(id),
    foreign key (fkItem) references item(id)
	);