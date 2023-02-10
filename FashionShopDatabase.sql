use master

if exists(select name from sysdatabases where name = 'FashionShop')
	drop database FashionShop
create database FashionShop
go

if exists(select name from sysobjects where name = 'Users')
	drop table Users
create table Users
(
	id BIGINT primary key,
	firstName char(20),
	lastName char(20),
	phoneNumber char(10),
	email char(150),
	password varchar,
	admin tinyint,
	adress varchar(150),
	province char(30),
	city char(30),
	country char(30)
)

if exists(select name from sysobjects where name = 'Users')
	drop table Users
create table Users
(
	id BIGINT primary key,
	firstName char(20),
	lastName char(20),
	phoneNumber char(10),
	email char(150),
	password varchar,
	admin tinyint,
	adress varchar(150),
	province char(30),
	city char(30),
	country char(30)
)