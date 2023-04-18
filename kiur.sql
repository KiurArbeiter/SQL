-- komm
-- teeb andmbeaasi ehk db
create database TARpe22

-- kustutab db
drop database TARpe22

-- tabeli loomine
create table Gender
(
Id int not null primary key,
Gender nvarchar(10) not null
)

---- andmete sisestamine
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
insert into Person (Id, Name, Email, GenderId)
values (1, 'Superman', 'superman@mail.com', 2)
insert into Person (Id, Name, Email, GenderId)
values (2, 'Wonderwoman', 'ww@mail.com', 1)
insert into Person (Id, Name, Email, GenderId)
values (3, 'Batman', 'bm@mail.com', 2)
insert into Person (Id, Name, Email, GenderId)
values (4, 'Aquaman', 'am@mail.com', 2)
insert into Person (Id, Name, Email, GenderId)
values (5, 'Catwoman', 'cw@mail.com', 1)
insert into Person (Id, Name, Email, GenderId)
values (6, 'Antman', 'ant"ant.com', 2)
insert into Person (Id, Name, Email, GenderId)
values (8, NULL, NULL, 2)

select * from Person

-- võõrvõtme ühenduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_GenderID_FK
foreign key (GenderId) references Gender(Id)

--- kui sisestad uue rea andmeid ja ei ole sisestatud GenderId all väärtust, siis
--- see automaatselt sisestab tabelisse väärtuse 3 ja selleks on Unknown
alter table Person
add constraint DF_Persons_GenderId
default 3 for GenderId

insert into Person (Id, Name, Email)
values (9, 'Ironman', 'i@i.com')

select * from Person

-- piirangu maha võtmine
alter table Person
drop constraint DF_Persons_GenderId

--- lisame uue veeru
alter table Person
add Age nvarchar(10)

--- lisame vanuse piirangu sisestamisel
--- ei saa lisada suuremat väärtust kui 801
alter table Person
add constraint CK_Person_Age check (Age > 0 and Age < 801)

-- rea kustutamine
-- kui paned vale id, siis ei muuda midagi
delete from Person where Id = 9

select * from Person

-- kuidas uuendada andmeid tabelis
update Person
set Age = 50
where Id = 1

-- lisame juurde uue veeru
alter table Person
add City nvarchar(50)

-- kõik, kes elavad gothami linnas
select * from Person where City = 'Gotham'
-- kõik, kes ei ela Gothamis
select * from Person where City != 'Gotham'
-- teine variant
select * from Person where not City = 'Gotham'
-- kolmas variant
select * from Person where City <> 'Gotham'

-- naitab teatud vanusega inimes
select * from Person where Age = 800 or Age = 35 or Age = 27
select * from Person where Age in (800, 35, 27)

-- naitab teatud vanusevahemikus olevaid inimesi
select * from Person where Age between 20 and 35

-- wildcard ehk naitab koik g-tahega linnad
select * from Person where City like 'g%'
-- naitab koik emailid, milles on @ mark
select * from Person where Email like '%@%'

--- näitab kõiki, kellel ei ole @-märki emailis
select * from Person where Email not like '%@%'

--- naitab kellel on emailis ees ja peale @-märki
select * from Person where Email like '_@_.com'

-- koik, kellel ei ole nimes esimene taht W, A, C
select * from Person where Name like '[^WAC]%'

--- kes elavad Gothamis ja New Yorkis
select * from Person where (City= 'Gotham' or City = 'New York')

-- koik kes elavad Gothamis ja New Yorkis ning
-- alla 30 eluaastat
select * from Person where
(City= 'Gotham' or City = 'New York')
and Age <= 30

--- kuvab tahestikulises jarjekorras inimesi ja vütab aluseks nime
select * from Person order by Name
-- kuvab ´vastupidises jarjekorras inimesi ja vütb aluseks nime
select * from Person order by Name desc

-- votab kolm esimest rida
select TOP 3 * from Person


--- 2 tund jahjah
--- muudab age muutuja int-iks ja naitab vanulises jarjekorras
select * from Person order by CAST(Age as int)

--- koikide isikute koondvanus
select SUM(CAST(Age as int)) from Person

--- naitab koige nooremat isikut
select MIN(CAST(Age as int)) from Person

--- naitab koige vaneamt isikut
select MAX(CAST(Age as int)) from Person


--- näeme konkreetses linnades olevate isikute koondvanust
--- enne oli age string, aga päringu ajhal muutsime sele int-ks
select City, SUM(cast(Age as int)) as TotalAge from Person group by City

--- kuidas saab koodiga muuta tabeli andmetüüpi ja selle pikkust
alter table Person
alter column Name nvarchar(25)

alter table Person
alter column Age int

--- kuvab esimeses reas välja toodud järjestuses ja muudab Age-i TotalAge-ks
--- teeb järjestuse vaatesse: City, GenderId ja järjestab omakorda City veeru järgi
select City, GenderId, SUM(Age) as TotalAge from Person
group by City, GenderId order by City

--- naitab, et mitu rida on selles tabelis
select COUNT(*) from Person

--- veergude lugemine
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Person'

--- naitab tulemust, et mitu inimest on genderid
--- väärtusega 2 konkreetses linnas
--- arvutab kokku vanuse
select GenderId, City, SUM(Age) as TotalAge, COUNT(Id) as [Total Person(s)]
from Person
where GenderId = '2'
group by GenderId, City

--- naitab, et mitu inimest on vanemad kui 41 ja kui palju igas linnas
select GenderId, City, SUM(Age) as TotalAge, COUNT(Id) as [Total Person(s)]
from Person
group by GenderId, City having SUM(Age) > 41

--- loome uued tabelid
create table Department
(
Id int primary key,
DepartmentName nvarchar(50),
Location nvarchar(50),
DepartmentHead nvarchar(50)
)

create table Employees
(
Id int primary key,
Name nvarchar(50),
Gender nvarchar(50),
Salary nvarchar(50),
DepartmentId int
)

insert into Department (Id, DepartmentName, Location, DepartmentHead) values
(1, 'IT', 'London', 'Rick'),
(2, 'Payroll', 'Delhi', 'Ron'),
(3, 'HR', 'New York', 'Christie'),
(4, 'Other Department', 'Sydney', 'Cindrella')

insert into Employees (Id, Name, Gender, Salary, DepartmentId) values
(1, 'Tom', 'Male', '4000', 1),
(2, 'Pam', 'Female', '3000', 3),
(3, 'John', 'Male', '3500', 1),
(4, 'Sam', 'Male', '4500', 2),
(5, 'Todd', 'Male', '2800', 2),
(6, 'Ben', 'Male', '7000', 1),
(7, 'Sara', 'Female', '4800', 3),
(8, 'Valarie', 'Female', '5500', 1),
(9, 'James', 'Male', '6500', NULL),
(10, 'Russell', 'Male', '8800', NULL)

select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id

--- lisame veeru nimega City
alter table Employees
add City nvarchar(50)

select * from Employees

--- arvutame ühe kuu palgafondi kokku
select SUM(cast(Salary as int)) from Employees
--- min palga saaja ja kuitahame max palga saajat, siis kasutame MIN asemele MAX panna
select MIN(cast(Salary as int)) from Employees
--- ühe kuu palgafond linnade lõikes
select City, SUM(cast(Salary as int)) as TotalSalary from Employees
group by City

--- linnad on tahestikulises jarjestuses
select City, SUM(cast(Salary as int)) as TotalSalary from Employees
group by City, Gender
order by City

--- loeb ara mitu inimest on nimekirjas
select COUNT(*) from Employees

--- vaatame mitu tootajat on soo ja linna kaupa
select Gender, City, SUM(cast(Salary as int)) as TotalSalary,
COUNT(Id) as [Total Employee(s)]
from Employees
group by Gender, City

--- näidata kõiki mehi linnade kaupa
select Gender, City, SUM(cast(Salary as int)) as TotalSalary,
COUNT(Id) as [Total Employee(s)]
from Employees
where Gender = 'Male'
group by Gender, City

--- näidata kõiki naisi linnade kaupa
select Gender, City, SUM(cast(Salary as int)) as TotalSalary,
COUNT(Id) as [Total Employee(s)]
from Employees
group by Gender, City
having Gender = 'Female'


--- vigane päring
select * from Employees where SUM(CAST(Salary as int)) > 4000

--- töötav variant
select Gender, City, SUM(CAST(Salary as int)) as [Total Salary],
COUNT(Id) as [Total Employee(s)]
from Employees group by Gender, City
having SUM(CAST(Salary as int)) > 4000

--- loome tabeli, milles hakatakse automaatselt nummerdama Id-d
create table Test1
(
Id int identity(1,1),
Value nvarchar(20)
)

insert into Test1 values('X')

select * from Test1

--- inner join
--- kuvab neid, kellel on DepartmentName all olemas vaartus
select Name, Gender, Salary, DepartmentName
from Employees
inner join Department
on Employees.DepartmentId = Department.Id

--- left join
--- kuidas saada koik andmed Employees-st katte
select Name, Gender, Salary, DepartmentName
from Employees
left join Department --- voib kasutada ka LEFT OUTER JOIN-i
on Employees.DepartmentId = Department.Id

--- naitab koik tootajad Employee tabelist ja Department tabelist
--- osakonnad, kuhu ei ole kedagi maaratud
select Name, Gender, Salary, DepartmentName
from Employees
right join Department --- voib kasutada ka RIGHT OUTER JOIN-i
on Employees.DepartmentId = Department.Id

--- kuidas saada koikide tabelite vaartused uhte paringusse
select Name, Gender, Salary, DepartmentName
from Employees
full outer join Department
on Employees.DepartmentId = Department.Id

---votab kaks allpool olevat tabelit kokku ja korrutab need omavahel labi
select Name, Gender, Salary, DepartmentName
from Employees
cross join Department

--- kuidas kuvada need isikud, kellel on Department NULL
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null

--- teine variant
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Department.Id is null

--- kuidas saame department tabelis oleva rea, kus on NULL
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null

--- full join
--- molema tabeli mitte-kattuvad vaartustega read kuvab valja
select Name, Gender, Salary, DepartmentName
from Employees
full join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null
or Department.Id is null

select * from dbo.DimEmployee
--- tahan teada saada, mis tahendab SalesTerritoryKey DimEmployee tabelis
--- inner join-i kasutada
select FirstName, LastName, Phone, SalesTerritoryCountry, SalesTerritoryGroup, SalesTerritoryRegion
from dbo.DimEmployee
inner join dbo.DimSalesTerritory
on dbo.DimEmployee.SalesTerritoryKey = dbo.DimEmployee.SalesTerritoryKey

--- tabeli muutmine koodiga, alguses vana tabeli nimi ja siis soovitud nimi
sp_rename 'Department', 'department123'

select E.Name as Employees, M.Name as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id


---alter table Employees
---add Veerunimi int

--- inner join
--- näitab ainult managerId all olevate isikute väärtuseid
select E.Name as Employees, M.Name as Manager
from Employees E
inner join Employees M
on E.ManagerId = M.Id

--- kõik saavad kõikide ülemused olla
select E.Name as Employee, M.Name as Manager
from Employees E
cross join Employees M

select ISNULL('Asdasdasd', 'No Manager') as Manager

--- NULL asemel kuvad no manager
select coalesce(NULL, 'No Manager') as Manager

--- neil kellel ei ole ülemus, siis paneb neile no Manager teksti
select E.Name as Employee, ISNUll(M.Name, 'No Manager') as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id


--- lisame tabelisse uued veerudõ
alter table Employees
add MiddleName nvarchar(30)
alter table Employees
add LastName nvarchar(30)


select * from Employees
--- uuendame koodia väärtuseid
update Employees
set FirstName = 'Tom', MiddleName = 'Nick', LastName = 'Jones'
where Id = 1
update Employees
set FirstName = 'Pam', MiddleName = NULL, LastName = 'Anderson'
where Id = 2
update Employees
set FirstName = 'John', MiddleName = NULL, LastName = NULL
where Id = 3
update Employees
set FirstName = 'SAM', MiddleName = NULL, LastName = 'Smith'
where Id = 4
update Employees
set FirstName = NULL, MiddleName = 'Todd', LastName = 'Someone'
where Id = 5
update Employees
set FirstName = 'Ben', MiddleName = 'Ten', LastName = 'Sven'
where Id = 6
update Employees
set FirstName = 'Sara', MiddleName = NULL, LastName = 'Connor'
where Id = 7
update Employees
set FirstName = 'Valarie', MiddleName = 'Balerine', LastName = NULL
where Id = 8
update Employees
set FirstName = 'James', MiddleName = '007', LastName = 'Bond'
where Id = 9
update Employees
set FirstName = NULL, MiddleName = NULL, LastName = 'Crowe'
where Id = 10

select * from employees

--- igast reast võtab esimeses täidetud lahtri ja kuvab ainult seda
select Id, coalesce(FirstName, MiddleName, LastName) as Name
from Employees

--- loome 2 tabelit
create table IndianCustomers
(
Id int identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)

create table UKCustomers
(
Id int identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)

--- sisestame tabelisse andmeid
insert into IndianCustomers(Name, Email) values
('Raj', 'R@R.com'),
('Sam','S@S.com')

insert into UKCustomers(Name, Email) values
('Ben', 'B@B.com'),
('Sam','S@S.com')

select * from IndianCustomers
select * from UKCustomers

--- kasutame union all, mis näitab kõiki ridu
select Id, Name, Email from IndianCustomers
union all
select Id, Name, Email from UKCustomers


--- korduvate väärutstega read pannakse ühte ja ei korrata
select Id, Name, Email from IndianCustomers
union
select Id, Name, Email from UKCustomers


--- kuidas sorteerida tulemust nime järgi
select Id, Name, Email from IndianCustomers
union
select Id, Name, Email from UKCustomers
order by Name

--- stored procedure
create procedure spGetEmployees
as begin
select FirstName, Gender from employees
end


--- nüüd saab kasutada selle nimelist stored procedurit
spGetEmployees
exec spGetEmployees
execute spGetEmployees

create proc spGetEmployeesByGenderAndDepartment
--- muutujad defineeritakse @ märgiga
@Gender nvarchar(20),
@DepartmentId int
as begin
select FirstName, Gender, DepartmentId from Employees
where Gender = @Gender
and DepartmentId = @DepartmentId
end

--- kindlasti tuleb sellele panna parameeter lõppu muidu annab errori
--- kindlasti peab jalgima jarjekorda mis on pandud sp-le
---parameetrite osas
spGetEmployeesByGenderAndDepartment 'Male', 1



spGetEmployeesByGenderAndDepartment
@DepartmentId = 1, @Gender = 'Male'

--- saab vaadata sp sisu
sp_helptext spGetEmployeesByGenderAndDepartment


select PersonType, NameStyle, FirstName, MiddleName, LastName
from Person.Person
cross join Person.PersonPhone

select SalesQuota, Bonus, Name
from Sales.SalesPerson
RIGHT JOIN Sales.SalesTerritory
on Sales.SalesPerson.TerritoryID = Sales.SalesTerritory.TerritoryID
--- selecti laheb mida otsid voi leida thad
--- from-i paned esimese tabeli nime mida ühendad
--- right join taha paned millega yhendada tahad
--- on paned esimese tabeli nime ja selle taha . ja valge voti, paned = ja teisele poole seda kirjutad teise tabeli nime ning selle musta votme (votmed voivad teistpidi olla ei maleta)

--- 3 tund

--- kuidas muuta sp-d ja võti peale, et keegi teine peale teie ei saaks seda muuta

alter proc spGetEmployeesByGenderAndDepartment
@Gender nvarchar(20),
@DepartmentId int
with encryption --paneb võtme peale
as begin
   select FirstName, Gender, DepartmentId from Employees where Gender = @Gender
   and DepartmentId = @DepartmentId
end

--sp tegemine
create proc spGetEmployeeCountByGender
@Gender nvarchar(20),
@EmployeeCount int output
as begin
   select @EmployeeCount= COUNT(Id) from Employees where Gender = @Gender
end


--- annab tulemuse, kus loendab ära nõutele vastavad read
--- prindib tulemuse kirja teel
declare @TotalCount int
execute spGetEmployeeCountByGender 'Male', @TotalCount out
if(@TotalCount = 0)
    print '@TotalCount is null'
else
    print '@Total is not null'
print @TotalCount


--- näitab ära et mitu rida vastab nõutele
declare @TotalCount int
execute spGetEmployeeCountByGender @EmployeeCount = @TotalCount out, @Gender = 'Male'
print @TotalCount

-- sp sisu vaatamine
sp_help spGetEmployeeCountByGender

-- tabeli info
sp_help Employees

-- kui soovid sp teksti näha
sp_helptext spGetEmployeeCountByGender

-- vaatame, millest sõltub see sp
sp_depends spGetEmployeeCountByGender

--- saame teada, mitu asja sõltub sellest tabelist
sp_depends Employees


create proc spGetNameById
@Id int,
@Name nvarchar(20) output
as begin
    select @Name = Id, @Name = FirstName from Employees
end

spGetNameById 1, 'Tom'

-- annab kogu tabeli ridade arvu
create proc spTotalCount2
@TotalCount int output
as begin
   select @TotalCount = COUNT(Id) from Employees
end

--- saame teada, et mitu rida andmeid on tabeis

declare @TotalEmployees int
execute  spTotalCount2 @TotalEmployees output
select @TotalEmployees

-- mis id all on keegi nime järgi
alter proc spGetNameById1
@Id int,
@FirstName nvarchar(50) output
as begin
   select @FirstName = FirstName from Employees where Id = @Id
end

--- annab tulemuse, kus id 1 realon keegi koos nimeda
declare @FirstName nvarchar(50)
execute spGetNameById1 1, @FirstName output
print 'Name of the employee = ' + @FirstName

declare
@FirstName nvarchar(20)
execute spGetNameById1, @FirstName out
print 'Name = ' + @FirstName


create proc spGetNameById2
@Id int
as begin
	return (select FirstName from Employees where Id = @Id)
end


--- tuleb veateade kuna kustutasime välja int-i, aga Tom on String andmetüüp
declare @EmployeeName nvarchar(50)
execute @Employee = spGetNameById2 1
print 'Name of the employee = ' + @EmployeeName

--- sisseehitatud string funktsioon see konverdib ASCII tähe väärtuse numbriks
select ASCII('a')
--- näitab A-tähte
select CHAR(64)

--- prindime kogu tähestiku välja 
declare @Start int
set @Start = 97
while (@Start <= 122)
begin
	select CHAR (@start)
	set @Start = @Start+1
end

---eemaldame tühjad kohad sulgudes
select LTRIM('		   Hello12')


--- tühikute eemaldamine
select * from dbo.Employees

select Ltrim(FirstName) as [First Name], MiddleName, LastName from Employees

---paremalt poolt tühjad stringid lõikab ära
select RTRIM('        Hello				')

--- keerab kooloni sees olevad andmed vastupidiseks
--- vastabalt upper ja lower ga saan muuta märkide suurust
--- reverse funktioon pöörab kõik ümber
select reverse(UPPER(LTRIM(FirstName))) as FirstName, MiddleName, LOWER(LastName),
RTRIM(LTRIM(FirstName)) + ' ' + MiddleName + ' ' + LastName as FullName
from Employees

--- saame teada mitu tähemärki on nimes
select FirstName, len(FirstName) as [Total Characters] from Employees

---Näeb ära mitu tähte on sõnal ja ei loe tühikuid sisse
select FirstName, len(Ltrim(FirstName)) as [Total Characters] from Employees

---Left, Right, substring
--- vasakult poolt neli esimest tähte
select LEFT('ABCDEF', 4)

--- paremalt poolt neli esimest tähte
select RIGHT('ABCDEF', 4)

--- kuvab @-märgi asetust
select CHARINDEX('@', 'Sara@aaa.com')

--- esimese nr peale komakohta näitab, et mitmendast alustab ja siis mitu nr peale seda kuvada
select SUBstring('PAM@bbb.com', 5,2)


--- @-märgist kuvab kolm tähemärki. Viimase nr-ga saab määrata pikkust
select SUBSTRING('pam@bbb.com', CHARINDEX('@', 'pam@bbb.com') + 1, 3)

--- peale @-märki reguleerin tähemärkide pikkuse näitamist
select SUBSTRING('pam@bbb.com', CHARINDEX('@', 'pam@bbb.com') + 3,
LEN('pam@bbb.com') - charindex('@', 'pam@bbb.com'))

--- saame teada domeeninimed emailidest 
select substring (Email, charindex('@', Email) + 1,)
LEN (Email) - charindex('@', Email)) as EmailDomain
From Employees

alter table Employees
add email nvarchar(20)


update Employees set Email = 'Tom@aaa.com' where Id = 1
update Employees set Email = 'Pam@bbb.com' where Id = 2
update Employees set Email = 'John@aaa.com' where Id = 3
update Employees set Email = 'Sam@bbb.com' where Id = 4
update Employees set Email = 'Todd@bbb.com' where Id = 5
update Employees set Email = 'Ben@ccc.com' where Id = 6
update Employees set Email = 'Sara@ccc.com' where Id = 7
update Employees set Email = 'Valarie@aaa.com' where Id = 8
update Employees set Email = 'James@bbb.com' where Id = 9
update Employees set Email = 'Russel@bbb.com' where Id = 10


--- lisame *-märgi teatud kohast
select FirstName, LastName,
	SUBSTRING(Email,1, 2) + REPLICATE('*', 5) + --- peale teist tähtemärki paneb viis tärni
	SUBSTRING(Email, Charindex('@', Email), len (Email) - charindex('@', Email) + 1) as Email --- kuni @-märgini e on dünaamiline
from Employees

--- kolm korda näitab stringis olevat väärtust
select replicate('asd', 3)

--- kuidas sisestada tühikut kahe nime vahele
select space(5)

--- tühikute arv kahe 
select FirstName + Space(25) + LastName as FullName
from Employees


--- PATINDEX
--- sama, mis charindex, aga dünaamilisem ja saab kasutada wildcardi
select Email, PATINDEX('%@aaa.com', Email) as FirstOccurence
from Employees
where PATINDEX('%@aaa.com', Email) > 0 --- leiab kõigi domeeni esindajad ja alates mitmendast märgist algab @-märk


--- kõik .com asendatakse .net -ga
select Email, REPLACE(Email, '.com', '.net') as ConvertedEmail
from Employees


--- soovin asendada peale esimest märki kolm tähte viie tärniga
Select FirstName, LastName, Email,
	STUFF(EMAIL, 2, 3, '*****') as StuffedEmail
From Employees


--- teeme tabeli
create table DateTime
(
C_time time,
c_date date,
c_smalldatetime smalldatetime,
c_datetime datetime,
c_datetime2 datetime2,
c_datetimeoffset datetimeoffset
)

select * from Datetime

---konkreetse masina kellaaeg
select GETDATE(), 'GETDATE()'

insert into DateTime
values (Getdate(), getdate(), getdate(), getdate(), getdate(), getdate())

update DateTime set c_datetimeoffset = '2023-04-11 11:53:29.8566667 +00:00'
where c_datetimeoffset = '2023-04-11 11:53:29.8566667 +00:00'

select 'CURRENT_TIMESTAMP' --- aja päring
select SYSDATETIME(), 'SYSDATETIME' --- veel täpsem aja päring
select SYSDATETIMEOFFSET() --- täpne aeg koos ajalise nihkega
select GETUTCDATE() --- UTC aeg


select ISDATE('asd') --- tagastab 0 kuna string ei ole date
select ISDATE(GETDATE()) --- tagastab 1 kuna on kp
select isdate('2023-04-11 11:53:29.8566667') --- tagastab 0 kuna max kolm komakohta voib olla
select isdate('2023-04-11 11:53:29.856') --- tagastab 1
select day(GETDATE()) --- annab tänase päeva numbri
select day('03/31/2020') --- annab stringis oleva kp ja järjestus peab olema õige
select MONTH(GETDATE())
select DAY('03/31/2020') -- annab stringis oleva kuu nr
select YEAR(GETDATE()) --- annab jooksva aasta nr
select YEAR('03/31/2020') --- annab stringis oleva aastsa nr

select DATENAME(DAY, '2023-04-11 11:53:29.856') --- annab päeva nr
select DATENAME(WEEkDAY, '2023-04-11 11:53:29.856') --- annab stringis oleva päeva sõnana
select DATETIME(MONTH, '2023-04-11 11:53:29.856')



create function fnComputeAge(@DOB datetime)
returns nvarchar(50)
as begin
	declare @tempdate datetime, @years int, @months int, @days int
		select @tempdate = @DOB

		select @years = DATEDIFF(YEAR, @tempdate, GETDATE()) - case when (MONTH(@DOB) > MONTH(GETDATE())) or (MONTH(@DOB))
		= MONTH(GETDATE()) and DAY(@DOB) > DAY(GETDATE()) then 1 else 0 end
		select @tempdate = DATEADD(YEAR, @years, @tempdate)

		select @months = DATEDIFF(MONTH, @tempdate, GETDATE()) - case when DAY(@DOB) > DAY(GETDATE()) then 1 else 0 end
		select @tempdate = DATEADD(MONTH, @months, @tempdate)

		select @days = DATEDIFF(DAY, @tempdate, GETDATE())

		declare @Age nvarchar(50)
		set @Age = CAST(@years as nvarchar(4)) + ' Years ' + CAST(@months as nvarchar(4)) + ' Months ' + CAST(@days as nvarchar(4)) + ' Days '
	return @Age
end



alter table Employees
add DateOfBirth datetime

--- saame vaadata kasutajate vanust
select Id, Name, DateOfBirth, dbo.fnComputeAge(DateOfBirth) as Age from Employees

-- kui kasutame seda funktsiooni siis saame teada tanse paeva vahe stringis valja toodud kuupaevaga
select dbo.fnComputeAge('11/11/2010')


--- nr peale dateofbirth muutujat naitab et mismoodi kuvada DOB
select Id, Name, DateOfBirth,
CONVERT(nvarchar, dateofbirth, 126) as convertedDOB
from Employees

select Id, Name, Name + ' - ' + CAST(Id as nvarchar) --- siin 2x name kuna mul pole second name!
as [Name-Id] from Employees


select CAST(GETDATE() as date) -- tanane kuupaev
select CONVERT(date, GETDATE()) -- tanane kuupaev

--- matemaatilisd funktsioonid
select ABS(-101.5) --- ABS on absoluutväärtus arvust, ehk alati positiivne
select CEILING(15.2) -- tagastab 16, CEILING suurendab täisarvu suunas
select CEILING(-15.2) -- tagastab -15, ja suurendab positiivse täisarvu suunas
select FLOOR(15.2) -- tagastab 15, suurendab täisarvu suunas
select FLOOR(-15.2) -- tagastab -15, suurendab vaiksema täisarvu suunas
select POWER(2, 4) -- hakkab korrutama 2*2*2*2, esimene on korrutatav number, teine on korrutaja
select SQUARE(9) -- votab ruutu
select SQRT(4) -- ruutjuur
select RAND() -- annab suvalise numbri
select FLOOR(RAND() * 100) -- korrutab 100 iga random numbri
