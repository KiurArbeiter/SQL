--- kommentaar
---- teeme andmebaasi e DB
create database TARpe22

-- db kustutamine
drop database TARpe22

-- tabeli loomine
create table Gender
(
Id int not null primary key,
Gender nvarchar(10) not null
)

--- andmete sisestamine
insert into Gender (Id, Gender)
values (2, 'Male')
insert into Gender (Id, Gender)
values (1, 'Female')
insert into Gender (Id, Gender)
values (3, 'Unknown')

--- sama Id väärtusega rida ei saa sisestada
select * from Gender

--- teeme uue tabeli
create table Person
(
	Id int not null primary key,
	Name nvarchar(30),
	Email nvarchar(30),
	GenderId int
)

--- vaatame Person tabeli sisu
select * from Person

--- andmete sisestamine
insert into Person (Id, name, Email, GenderId)
values (1, 'Superman', 'Super@mail.com', 2)
insert into Person (Id, name, Email, GenderId)
values (2, 'Wonderwoman', 'Wonder@mail.com', 1)
insert into Person (Id, name, Email, GenderId)
values (3, 'Batman', 'Bat@mail.com', 2)
insert into Person (Id, name, Email, GenderId)
values (4, 'Aquaman', 'Aqua@mail.com', 2)
insert into Person (Id, name, Email, GenderId)
values (5, 'Catwoman', 'Cat@mail.com', 1)
insert into Person (Id, name, Email, GenderId)
values (6, 'Antman', 'Ant@mail.com', 2)
insert into Person (Id, name, Email, GenderId)
values (8, NULL, NULL, 2)

select * from Person

--võõrvõtme ühenduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_GenderId_FK
foreign key (GenderId) references Gender(Id)

--- kui sisestad uue rea andmeid ja ei ole sistanud GenderId all väärtust, siis
--- see automaatselt sisestab tabelisse väärtuse 3 ja selleks on unknown
alter table Person
add constraint DF_Persons_GenderId
default 3 for GenderId

Insert into Person (Id, name, Email)
values (9, 'Ironman', 'Iron@mail.com')

select * from Person

--piirangu maha võtmine
alter table Person
drop constraint DF_Persons_GenderId

--- lisame uue veeru
alter table Person
add Age nvarchar(10)

--- lisame vanuse piirangu sisestamisel
--- ei saa lisada suuremat väärtust, kui 801
alter table Person
add constraint CK_Person_Age check (Age > 0 and Age < 801)

--rea kustutamine

delete from Person where Id = 9

select * from Person

-- kuidas uuendada andmeid tabelis
update Person
set Age = 50
where Id = 1

-- lisama juurde uue veeru
alter table Person
add City nvarchar(50)

-- kõik kes elavad Gothami linnas
select * from Person where City = 'Gotham'
-- kõik, kes ei ela Gothami linnas variant 1
select * from Person where not City = 'Gotham'
-- kõik, kes ei ela Gothami linnas variant 2
select * from Person where city != 'Gotham'
-- kõik, kes ei ela Gothami linnas variant 3
select * from Person where city <> 'Gotham'

select * from Person where Age = 800 or Age = 35 or Age = 27
select * from Person where Age in (800, 35, 27)

-- näitab teatud vanusevahemikus olevaid inimesi
select * from Person where Age between 20 and 35

-- wildcar ehk näitab kõik G-T tähega linnad
select * from Person where City like 'g%'
-- näitab kõik emaili, milles on @ märk 
select * from Person where Email like '%@%'

--- näitab koiki kellel ei ole @marki emailis
select * from Person where Email not like '%@%'

--- näitab, kellel on emailis ees ja peale @märki
select * from Person where Email like '_@_.com'

-- kõik, kellel ei ole nimes esimene täht W, A, C
select * from person where name like '[^WAC]%'

-- kes elavad Gothamis ja New York
select * from person where (City = 'Gotham' or City = 'New York')
-- koik kes elavad Gothamis ja New Yorkis ning
-- üle 30 eluaastat
select * from person where (City = 'Gotham' or City = 'New York') and (Age >= 30)


--- kuvab tähestikulises järjekorras inimesi ja võtab aluseks nime
select * from Person order by Name
-- kuvad vastupidises järjekorras
select * from Person order by name desc

-- võtab kolm esimest rida
select top 3 * from Person

--- 2 tund 