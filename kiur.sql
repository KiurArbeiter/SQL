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
FirstName nvarchar(30),
Email nvarchar(30),
GenderId int
)

--- vaatame Person tabeli sisu
select * from Person

--- andmete sisestamine
insert into Person (Id, FirstName, Email, GenderId)
values (1, 'Superman', 'superman@mail.com', 2)
insert into Person (Id, FirstName, Email, GenderId)
values (2, 'Wonderwoman', 'ww@mail.com', 1)
insert into Person (Id, FirstName, Email, GenderId)
values (3, 'Batman', 'bm@mail.com', 2)
insert into Person (Id, FirstName, Email, GenderId)
values (4, 'Aquaman', 'am@mail.com', 2)
insert into Person (Id, FirstName, Email, GenderId)
values (5, 'Catwoman', 'cw@mail.com', 1)
insert into Person (Id, FirstName, Email, GenderId)
values (6, 'Antman', 'ant"ant.com', 2)
insert into Person (Id, FirstName, Email, GenderId)
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

insert into Person (Id, FirstName, Email)
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
select * from Person where FirstName like '[^WAC]%'

--- kes elavad Gothamis ja New Yorkis
select * from Person where (City= 'Gotham' or City = 'New York')

-- koik kes elavad Gothamis ja New Yorkis ning
-- alla 30 eluaastat
select * from Person where
(City= 'Gotham' or City = 'New York')
and Age <= 30

--- kuvab tahestikulises jarjekorras inimesi ja vütab aluseks nime
select * from Person order by FirstName
-- kuvab ´vastupidises jarjekorras inimesi ja vütb aluseks nime
select * from Person order by FirstName desc

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
alter column FirstName nvarchar(25)

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
WHERE TABLE_FirstName = 'Person'

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
DepartmentFirstName nvarchar(50),
Location nvarchar(50),
DepartmentHead nvarchar(50)
)

create table Employees
(
Id int primary key,
FirstName nvarchar(50),
Gender nvarchar(50),
Salary nvarchar(50),
DepartmentId int
)

insert into Department (Id, DepartmentFirstName, Location, DepartmentHead) values
(1, 'IT', 'London', 'Rick'),
(2, 'Payroll', 'Delhi', 'Ron'),
(3, 'HR', 'New York', 'Christie'),
(4, 'Other Department', 'Sydney', 'Cindrella')

insert into Employees (Id, FirstName, Gender, Salary, DepartmentId) values
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

select FirstName, Gender, Salary, DepartmentFirstName
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
--- kuvab neid, kellel on DepartmentFirstName all olemas vaartus
select FirstName, Gender, Salary, DepartmentFirstName
from Employees
inner join Department
on Employees.DepartmentId = Department.Id

--- left join
--- kuidas saada koik andmed Employees-st katte
select FirstName, Gender, Salary, DepartmentFirstName
from Employees
left join Department --- voib kasutada ka LEFT OUTER JOIN-i
on Employees.DepartmentId = Department.Id

--- naitab koik tootajad Employee tabelist ja Department tabelist
--- osakonnad, kuhu ei ole kedagi maaratud
select FirstName, Gender, Salary, DepartmentFirstName
from Employees
right join Department --- voib kasutada ka RIGHT OUTER JOIN-i
on Employees.DepartmentId = Department.Id

--- kuidas saada koikide tabelite vaartused uhte paringusse
select FirstName, Gender, Salary, DepartmentFirstName
from Employees
full outer join Department
on Employees.DepartmentId = Department.Id

---votab kaks allpool olevat tabelit kokku ja korrutab need omavahel labi
select FirstName, Gender, Salary, DepartmentFirstName
from Employees
cross join Department

--- kuidas kuvada need isikud, kellel on Department NULL
select FirstName, Gender, Salary, DepartmentFirstName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null

--- teine variant
select FirstName, Gender, Salary, DepartmentFirstName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Department.Id is null

--- kuidas saame department tabelis oleva rea, kus on NULL
select FirstName, Gender, Salary, DepartmentFirstName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null

--- full join
--- molema tabeli mitte-kattuvad vaartustega read kuvab valja
select FirstName, Gender, Salary, DepartmentFirstName
from Employees
full join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null
or Department.Id is null

select * from dbo.DimEmployee
--- tahan teada saada, mis tahendab SalesTerritoryKey DimEmployee tabelis
--- inner join-i kasutada
select FirstFirstName, LastFirstName, Phone, SalesTerritoryCountry, SalesTerritoryGroup, SalesTerritoryRegion
from dbo.DimEmployee
inner join dbo.DimSalesTerritory
on dbo.DimEmployee.SalesTerritoryKey = dbo.DimEmployee.SalesTerritoryKey

--- tabeli muutmine koodiga, alguses vana tabeli nimi ja siis soovitud nimi
sp_reFirstName 'Department', 'department123'

select E.FirstName as Employees, M.FirstName as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id


---alter table Employees
---add Veerunimi int

--- inner join
--- näitab ainult managerId all olevate isikute väärtuseid
select E.FirstName as Employees, M.FirstName as Manager
from Employees E
inner join Employees M
on E.ManagerId = M.Id

--- kõik saavad kõikide ülemused olla
select E.FirstName as Employee, M.FirstName as Manager
from Employees E
cross join Employees M

select ISNULL('Asdasdasd', 'No Manager') as Manager

--- NULL asemel kuvad no manager
select coalesce(NULL, 'No Manager') as Manager

--- neil kellel ei ole ülemus, siis paneb neile no Manager teksti
select E.FirstName as Employee, ISNUll(M.FirstName, 'No Manager') as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id


--- lisame tabelisse uued veerudõ
alter table Employees
add MiddleFirstName nvarchar(30)
alter table Employees
add LastFirstName nvarchar(30)


select * from Employees
--- uuendame koodia väärtuseid
update Employees
set FirstFirstName = 'Tom', MiddleFirstName = 'Nick', LastFirstName = 'Jones'
where Id = 1
update Employees
set FirstFirstName = 'Pam', MiddleFirstName = NULL, LastFirstName = 'Anderson'
where Id = 2
update Employees
set FirstFirstName = 'John', MiddleFirstName = NULL, LastFirstName = NULL
where Id = 3
update Employees
set FirstFirstName = 'SAM', MiddleFirstName = NULL, LastFirstName = 'Smith'
where Id = 4
update Employees
set FirstFirstName = NULL, MiddleFirstName = 'Todd', LastFirstName = 'Someone'
where Id = 5
update Employees
set FirstFirstName = 'Ben', MiddleFirstName = 'Ten', LastFirstName = 'Sven'
where Id = 6
update Employees
set FirstFirstName = 'Sara', MiddleFirstName = NULL, LastFirstName = 'Connor'
where Id = 7
update Employees
set FirstFirstName = 'Valarie', MiddleFirstName = 'Balerine', LastFirstName = NULL
where Id = 8
update Employees
set FirstFirstName = 'James', MiddleFirstName = '007', LastFirstName = 'Bond'
where Id = 9
update Employees
set FirstFirstName = NULL, MiddleFirstName = NULL, LastFirstName = 'Crowe'
where Id = 10

select * from employees

--- igast reast võtab esimeses täidetud lahtri ja kuvab ainult seda
select Id, coalesce(FirstFirstName, MiddleFirstName, LastFirstName) as FirstName
from Employees

--- loome 2 tabelit
create table IndianCustomers
(
Id int identity(1,1),
FirstName nvarchar(25),
Email nvarchar(25)
)

create table UKCustomers
(
Id int identity(1,1),
FirstName nvarchar(25),
Email nvarchar(25)
)

--- sisestame tabelisse andmeid
insert into IndianCustomers(FirstName, Email) values
('Raj', 'R@R.com'),
('Sam','S@S.com')

insert into UKCustomers(FirstName, Email) values
('Ben', 'B@B.com'),
('Sam','S@S.com')

select * from IndianCustomers
select * from UKCustomers

--- kasutame union all, mis näitab kõiki ridu
select Id, FirstName, Email from IndianCustomers
union all
select Id, FirstName, Email from UKCustomers


--- korduvate väärutstega read pannakse ühte ja ei korrata
select Id, FirstName, Email from IndianCustomers
union
select Id, FirstName, Email from UKCustomers


--- kuidas sorteerida tulemust nime järgi
select Id, FirstName, Email from IndianCustomers
union
select Id, FirstName, Email from UKCustomers
order by FirstName

--- stored procedure
create procedure spGetEmployees
as begin
select FirstFirstName, Gender from employees
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


select PersonType, FirstNameStyle, FirstName, MiddleFirstName, LastFirstName
from Person.Person
cross join Person.PersonPhone

select SalesQuota, Bonus, FirstName
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


create proc spGetFirstNameById
@Id int,
@FirstName nvarchar(20) output
as begin
    select @FirstName = Id, @FirstName = FirstName from Employees
end

spGetFirstNameById 1, 'Tom'

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
alter proc spGetFirstNameById1
@Id int,
@FirstName nvarchar(50) output
as begin
   select @FirstName = FirstName from Employees where Id = @Id
end

--- annab tulemuse, kus id 1 realon keegi koos nimeda
declare @FirstName nvarchar(50)
execute spGetFirstNameById1 1, @FirstName output
print 'FirstName of the employee = ' + @Firstname


declare
@Firstname nvarchar(20)
execute spGetFirstNameById1 1, @FirstName out
print 'FirstName = ' + @FirstName


create proc spGetFirstNameById2
@Id int
as begin
   return (select FirstName from Employees where Id = @Id)
end

--- tuleb veateade kuna kutsusime välja int i, aga Tom on string andmetüüp
declare @EmployeeFirstName nvarchar(50)
execute @EmployeeFirstName = spGetFirstNameById2 1
print 'FirstName of the employee = ' + @EmployeeFirstName

---

--- sisseehitatud string funktsioon
--- see konverteerib ASCII tähe väärtuse numbriks
select ASCII('a')
--- näitab A´-tähte
select CHAR(65)

-- prindime kogu tähestiku välja
declare @Start int
set @Start = 97
while (@Start <= 122)
begin
    select CHAR (@Start)
set @Start = @Start+1
end

--- eemaldame tühjad kohad sulgudes
select LTRIM('               Hello')

--- tühikute eemaldamine veerust
select * from dbo.Employees

-- tühikute eemaldamine veerust
select LTRIM(FirstName) as [First FirstName], MiddleFirstName, LastFirstName from Employees

-- paremalt poolt tühjad stringid lõikab ära
select RTRIM('        Hello               ')

--- keerab kooloni sees olevad andmed vastupidiseks
--- vastavalt upper ja lower-ga saan muuta märkide suurust
--- reverse funktsioon pöörab kõik ümber
select REVERSE(UPPER(LTRIM(FirstName))) as FirstName, MiddleFirstName, LOWER(LastFirstName),
RTRIM(LTRIM(FirstName)) + ' ' + MiddleFirstName + ' ' + LastFirstName as FullFirstName
from Employees

-- näeb ära, et mitu tähemärki on nimes ja loeb tühikud sisse
select FirstName, LEN(FirstName) as [Total Characters] from Employees

--- näeb ära, mitu tähte on sõnal ja ei loe tühikuid sisse
select FirstName, LEN(ltrim(FirstName)) as [Total Characters] from Employees


--- left, right, substring
--- vasakult poolt neli esimest tähte
select LEFT('ABCDEF', 4)

--- paremalt poolt kolm tähte
select RIGHT('ABCDEF', 4)

--- kuvab @-tähemärki asetust
select CHARINDEX('@', 'sara@aaa.com')

--- esimene nr peale komakohta näitab, et mitmendast alustab
--- ja siis mitu nr peale seda kuvada
select SUBSTRING('pam@bbb.com', 5,2)

-- @-märgist kuvab kolm tähemärki. Viimase nr-ga saab määrata pikkust
select SUBSTRING('pam@bbb.com', CHARINDEX('@', 'pam@bbb.com') + 1, 3)

---peale @-tähemärki reguleerin tähemärkide pikkuse näitamist
select SUBSTRING('pam@bbb.com', CHARINDEX('@', 'pam@bbb.com') + 2,
LEN('pam@bbb.com') - CHARINDEX('@','pam@bbb.com'))

--- saame teada domeeninimede emailides
select SUBSTRING (Email, charindex('@', Email)) + 1,
LEN (Email) - CHARINDEX('@', Email)) as EmailDomain
from Employees

alter table Employees
add Email nvarchar(20)

update Employees set Email = 'Tom@aaa.com' where Id = 1
update Employees set Email = 'Pam@bbb.com' where Id = 2
update Employees set Email = 'John@aaa.com' where Id = 3
update Employees set Email = 'Sam@bbb.com' where Id = 4
update Employees set Email = 'Todd@bbb.com' where Id = 5
update Employees set Email = 'Ben@ccc.com' where Id = 6
update Employees set Email = 'Sara@ccc.com' where Id = 7
update Employees set Email = 'Vlarie@aaa.com' where Id = 8
update Employees set Email = 'James@bbb.com' where Id = 9
update Employees set Email = 'Russel@bbb.com' where Id = 10

select * from Employees


--- lisame *-märgi teatud kohast
select FirstName, LastFirstName,
    SUBSTRING(Email,1, 2) + REPLICATE('*', 5) + --- peale teist tähemärki paneb viis tärni
SUBSTRING(Email, charindex('@', Email), len(Email) - CHARINDEX('@', Email)+1) as Email --- kuni @-märginin on dünaamiline
from Employees

--- kolm korda näitab stringis olevat väärtust
select REPLICATE('asd', 3)

--- kuidas sisestada tühikut kahe nime vahele
select SPACE(5)

--- tühikute arv kahe nime vahel
select FirstName + SPACE(25) + LastFirstName as FullFirstName
from Employees

---PATINDEX
--- sama, mis CHARINDEX, aga dünaamilisem ja saab kasutada wildcardi
select Email, PATINDEX('%@aaa.com', Email) as FirstOccurence
from Employees
where PATINDEX('%@aaa.com', Email) > 0 --- leiab kõik selle domeeni esindajad
-- ja alates mitmendast märgist algab @

--- kõik .com-d asendatakse .net-ga
select Email, REPLACE(Email, '.com', '.net') as ConvertedEmail
from Employees

--- soovin asendada peale esimest märki kolm tähte viie tärniga
select FirstName, LastFirstName, Email,
    STUFF(Email, 2, 3, '*****') as StuffedEmail
from Employees

--- teeme tabeli
create table DateTime
(
c_time time,
c_date date,
c_smalldatetime smalldatetime,
c_datetime datetime,
c_datetime2 datetime2,
c_datetimeoffset datetimeoffset
)

select * from DateTime

--- konkreetse masina kellaaeg
select GETDATE(), 'GETDATE()'

insert into DateTime
values (GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE())

select * from DateTime

update DataTime set c_datetimeoffset = '2022-04-11 11:50:40.0366667 +00:00'
where c_datetimeoffset = '2023-04-11 11:50:40.0366667 +00:00'

select CURRENT_TIMESTAMP, 'CURRENT_TIMESTAMP' --aja päring
select SYSDATETIME(), 'SYSDATETIME' -- veel täpsem aja päring
select SYSDATETIMEOFFSET() --- täpne aeg koos ajalise nihkega
select GETUTCDATE() --- UTC aeg


select ISDATE('asd') -- tagastab 0 kuna string ei ole date
select ISDATE(GETDATE())  -- tagastab 1 kuna on kp
select ISDATE('2022-04-11 11:50:40.0366667') --- tagastab 0 kuna max kolm komakohta
select ISDATE('2022-04-11 11:50:40.037') --- tagastab 1
select DAY(GETDATE()) --- annab kuupäeva
select DAY('11/09/2001') -- anab stringis oleva kp ja järjestus peab olema õige
select MONTH(getdate()) -- annab jooksva kuu nr
select MONTH('11/09/2001') -- annab stringis oleva kuu nr
select YEAR(getdate()) -- annab jooksva kuu nr
select YEAR('11/09/2001') -- annab stringis oleva kuu nr

select DATEFirstName(DAY, '2022-04-11 11:50:40.037') --- annab stringis oleva päeva nr
select DATEFirstName(WEEKDAY, '2022-04-11 11:50:40.037') --- annab stringis oleva päeva
select DATEFirstName(MONTH, '2022-04-11 11:50:40.037') --- annab stringis oleva


--- 5 tund

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
select Id, FirstName, DateOfBirth, dbo.fnComputeAge(DateOfBirth)
as Age from Employees

-- kui kasutame seda funktsiooni, siis saame teada tänase päeva vahe
-- stringis välja toodud kuupäevaga
select dbo.fnComputeAge('11/11/2010')

-- nr peale dateofbirth muutujat näitab, et mismoodi kuvada DOB
select Id, FirstName, DateOfBirth,
CONVERT(nvarchar, DateOfBirth, 101) as ConvertedDOB
from Employees

select Id, FirstName + ' - ' + CAST(Id as nvarchar)
as [FirstName-Id]  from Employees

select CAST (GETDATE() as date) --- tänane kp
select CONVERT(date, getdate()) -- tänane kp

---matemaatilised funktsioonid
SELECT ABS(-101.5) -- absoluutväärtus, tulemus ilma miinuseta
SELECT CEILING(15.2) -- tagastab 16 ja suurendab suurema täisarvu suunas
SELECT CEILING(-15.2) -- tagastab -15 ja suurendab suurema positsiivse täisarvu suunas
SELECT FLOOR(-15.2) -- ümmardab negatiivsema nr poole
SELECT FLOOR(15.2) -- ümmardab negatiivsema nr poole
SELECT POWER(2, 4) -- hakkab korrutama 2*2*2*2, esimene number on korrutatav number
SELECT SQUARE(9) -- vastuseks saame 9 ruudus ehk 9*9
SELECT SQRT(81)-- leiab ruutjuure

SELECT RAND() -- annab suvalise nr
SELECT FLOOR(rand() * 100)-- korrutab sajaga iga suvalise numbri


---- 6 tund
---iga kord näitab 10 suvalist nr-t
declare @counter int
set @counter = 1
WHILE (@counter <= 10)
   begin
      print floor(rand() * 1000)
 set @counter = @counter + 1
end

select ROUND(850.556, 2) -- ümmardab kaks kohta peale koma
select ROUND(850.556, 2, 1) -- ümmardab allapoole 850.550
select ROUND(850.556, 1) -- ümmardab ülespoole
select ROUND(850.556, 1, 1) -- ümmardab allapoole
select ROUND(850.556, -2) -- ümmardab esimese täisnr ülesse
select ROUND(850.556, -1) -- ümmardab esimese täisnr alla



---
create function dbo.CalculateAge (@DOB date)
returns int
as begin
declare @Age int
set @Age = DATEDIFF(year, @DOB, GETDATE()) -
   case
      when (MONTH(@DOB) > MONTH(GETDATE())) or
      (MONTH (@DOB) > MONTH(GETDATE()) and DAY(@DOB) > DAY(GETDATE()))
  then 1
  else 0
  end
   return @Age
 end

execute CalculateAge '10/08/2020'


select * from Employees


-- arvutab välja, kui vana on isik ja võtab arvesse kuud ning päevad
--- antud juhul näitab kõike, kes on üle 26 a vanad
select Id, FirstName, dbo.CalculateAge(DateOfBirth) as Age
from Employees
where dbo.CalculateAge(DateOfBirth) > 26

--- lisame veeru juurde
alter table Employees
add DepartmentId int

-- scalar function annab mingis vahemikus olevaid andmeid,
-- aga inline table values ei kasuta begin ja end funktsioone
-- scalar annab väärtused ja inline annab tabeli
create function fn_EmployeesByGender(@Gender nvarchar(10))
returns table
as
return (select Id, FirstName, DateOfBirth, DepartmentId, Gender
        from Employees
where Gender = @Gender)

--- kõik female töötajad
select * from fn_EmployeesByGender('Female')


select * from fn_EmployeesByGender('Female')
where FirstName = 'Pam' --where abil saab otsingut täpsustada

select * from Department

---kahest erinevast tabelist andmete võtmine ja koos kuvamine
---esimene on funktsioon ja teine tabel

select FirstName, Gender, DepartmentFirstName
from  fn_EmployeesByGender('Female')
E join Department D on D.Id = E.DepartmentId

---multi-table statment

--inline funktsioon
create function fn_GetEmployees()
returns table as
return (select Id, FirstName, CAST(DateOfBirth as date)
        as DOB
from Employees)

select * from fn_GetEmployees()

--multi-state puhul peab defineerima uue tabeli veerud koos muutujatega
create function fn_MS_GetEmployees()
returns @Table Table (Id int, FirstName nvarchar(20), DOB date)
as begin
   insert into @Table
   select Id, FirstName, CAST(DateOfBirth as date) from Employees

   return
end

select * from fn_MS_GetEmployees()

--inline tabeli funktsioon on paremini töötamas kuna käsitletakse vaatena
--multi puhul on põhimõtteliselt tegemist stored proceduriga ja kulutab rohkem ressurssi

-- saab andmeid muuta
update fn_GetEmployees() set FirstName = 'Sam1' where Id = 1
-- ei saa muuta andmeid
update fn_MS_GetEmployees() set FirstName = 'Sam2' where Id = 1

select * from Employees

--ettemääratud ja mitte ettemääratud

select COUNT(*) from Employees
select SQUARE(3) -- kõik tehtemärgid on ette määratud funktsioonid
--ja sinna kuuluvad veel sum, avg, square

-- mitte ettemääratud
select GETDATE()
select CURRENT_TIMESTAMP
select rand() -- see funktsioon saab olla mõlemas kategoorias,
-- kõik oleneb selles, kas sulgudes on 1 või ei ole

---loome funktsiooni
create function fn_GetFirstNameById(@id int)
returns nvarchar(30)
as begin
   return (select FirstName from Employees where Id = @id)
end

select dbo.fn_GetFirstNameById(7)

select * from Employees

sp_helptext fn_GetFirstNameById

-- loome funktisooni, mille sisu krüpteerime ära
create function fn_GetEmployeeFirstNameById(@id int)
returns nvarchar(30)
as begin
   return (select FirstName from Employees where Id = @id)
end

-- muudame funktsiooni sisu ja krüpteerime ära
alter function fn_GetFirstNameById(@id int)
returns nvarchar(30)
with encryption
as begin
   return (select FirstName from Employees where Id = @id)
end

--tahame krüpteeritud funktsiooni sisu näha, aga ei saa
sp_helptext fn_GetEmployeeFirstNameById

alter function fn_GetFirstNameById(@id int)
returns nvarchar(30)
with schemabinding
as begin
   return (select FirstName from Employees where Id = @id)
end

--- temporary tables
-- #-märgi ette panemisel saame aru, et tegemist on temp tableiga
-- seda tabelit saab ainult selles päringus avada
create table #PersonDetails(Id int, FirstName nvarchar(20))

insert into #PersonDetails values(1, 'Ben')
insert into #PersonDetails values(2, 'John')
insert into #PersonDetails values(3, 'Todd')
-- teie ülesanne on otsida ülesse temporary table

select * from #PersonDetails

Select FirstName from sysobjects
where FirstName like '#PersonDetails%'

--- kustutame temp table
drop table #PersonDetails

--- teeme stored procedure
create proc spCreateLocalTempTable
as begin
create table #PersonDetails(Id int, FirstName nvarchar(20))

insert into #PersonDetails values(1, 'Ben')
insert into #PersonDetails values(2, 'John')
insert into #PersonDetails values(3, 'Todd')

select * from #PersonDetails
end

exec spCreateLocalTempTable

--- globaalse temp tabeli tegemine
create table ##PersonDetails(Id int, FirstName nvarchar(20))

select * from Employees

select * from Employees
where Salary > 5000 and Salary < 7000

--- loome indeksi, mis asetab palga kahanevasse järjestusse
create index IX_Employee_Salary
on Employees (Salary asc)

---saame teada, et mis on selle tabeli primaarvõti ja index
exec sys.sp_helpindex @objFirstName = 'Employees'

---indeksi kustutamine
drop index Employees.IX_Employee_Salary

---indeksi tüübid:
--1. Klastrites olevad
--2. Mitte klastris olevad
--3. Unikaalsed
--4. Filtreeritud
--5. XML
--6. Täistekts
--7. Ruumiline
--8. Veerusäilitav
--9. Veegude indeksid
--10. Välja arvatud veergude indeksid

create table EmployeeCity
(
Id int primary key,
FirstName nvarchar(50),
Salary int,
Gender nvarchar(10),
City nvarchar(20)
)

exec sp_helpindex EmployeeCity
--- andmete õige järjestuse loovad klastris olevad indeksid ja kasutab selleks
-- põhjus, miks antud juhul kasutab Id-d, tuleneb primaarvõtmest

insert into EmployeeCity values(3, 'John', 4500, 'Male', 'New York')
insert into EmployeeCity values(1, 'Sam', 2500, 'Male', 'London')
insert into EmployeeCity values(4, 'Sara', 5500, 'Female', 'Tokyo')
insert into EmployeeCity values(5, 'Todd', 3100, 'Male', 'Toronto')
insert into EmployeeCity values(2, 'Pam', 6500, 'Male', 'Sydney')

select * from EmployeeCity

---klastris olevad indeksid dikteerivad säilitatud andmete järjestuse tabelis
--ja seda saab klastrite puhul olla ainult üks

create clustered index IX_EmployeeCity_FirstName
on EmployeeCity(FirstName)

---annab veateate, et tabelis saab olla ainult üks klastris olev indeks
-- kui soovid, uut indeksit luua, siis kustuta olemasolev

-- saame luua ainult üks klastris oleva indeksi tabeli peale
-- klastris olev indeks on analoogne telefoni suunakoodile

-- loome composite index-i
---enne tuleb kõik teised klastris olevad indeksid ära kustutada

create clustered index IX_Employee_Gender_Salary
on EmployeeCity(Gender desc, Salary asc)

drop index EmployeeCity.PK__Employee__3214EC07D2106287
-- koodiga ei saa kustutada Id-d, aga käsitsi saab

select * from EmployeeCity

--- erinevused kahe indeksi vahel
--- 1. ainult üks klastris olev indeks saab olla tabeli peale,
--- mitte klastris olevaid indekseid saab olla mitu
--- 2. klastris olevad indeksid on kiiremad kuna indeks peab tagasi viitama tabeli
--- juhul, kui selekteeritud veerg ei ole olemas indeksis
--- 3. Klastris olev indeks määratleb ära tabeli ridade slavestusjärjestuse
--- ja ei nõua kettal lisa ruumi. Samas mitte klastris olevad indkesid on
--- salvestatud tabelist eraldi ja nõuab lisa ruumi

create table EmployeeFirstName
(
Id int primary key,
FirstName nvarchar(50),
LastFirstName nvarchar(50),
Salary int,
Gender nvarchar(10),
City nvarchar(25)
)

exec sp_helpindex EmployeeFirstName

---ei saa sisestada kahte samasuguse Id väärtusega rida
insert into EmployeeFirstName values(1, 'Mike', 'Sandoz', 4500, 'Male', 'New York')
insert into EmployeeFirstName values(1, 'John', 'Mendoz', 4500, 'Male', 'London')

drop index EmployeeFirstName
---SQL server kasutab UNIQUE indeksit jõustamaks väärtuse unikaalsust ja  primaarvõtit

-- unikaalsed indekseid kasutatakse kindlustamaks väärtuste unikaalsust
-- (Sinna hulka primaarvõtme oma)


create unique nonclustered index UIX_Employee_FirstName_LastFirstName
on EmployeeFirstName(FirstName, LastFirstName)

insert into EmployeeFirstName values(1, 'Mike', 'Sandoz', 4500, 'Male', 'New York')
insert into EmployeeFirstName values(2, 'John', 'Mendoz', 4500, 'Male', 'London')

truncate table EmployeeFirstName

-- lisame uue unikaalse piirangu
alter table EmployeeFirstName
add constraint UQ_EmployeeFirstName_City
unique nonclustered(City)

--ei luba tabelisse väärtusega uut John Mendoz-t lisada kuna see on juba olemas
insert into EmployeeFirstName values(3, 'John', 'Mendoz', 3500, 'Male', 'London')

--- saab vaadata indeksite nimekirja
exec sp_helpconstraint EmployeeFirstName

-- 1. Vaikimisi primaarvõti loob unikaalse klastris oleva indeksi, samas
-- unikaalne piirang loob unikaalse mitte-klastris oleva indeksi
-- 2. Unikaalset indeksit või piirangut ei saa luua olemasolevasse tabelisse,
-- kui tabel juba sisaldab väärtusei võtme veerus
-- 3. Vaikimisi korduvaid väärtuseid ei ole veerus lubatud,
-- kui peaks olema unikaalne indeks või piirang. Nt, kui tahad sisestada
-- 10 rida andmeid, millest 5 sisaldavad korduvaid andmeid, siis kõik 10
-- lüjatajse tagasi. Kui soovin ainult 5 rea tagasi lükkamist ja ülejäänud
-- 5 rea siestamist, siis selleks kasutatakse INGORE_DUP_KEY

--- koodinäide:
create unique index IX_EmployeeFirstName
on EmployeeFirstName(City)
with IGNORE_DUP_KEY

---enne koodi sisestamist kustuta indeksi kaustas UQ_EmployeeFirstName_City ära
insert into EmployeeFirstName values(3, 'John', 'Mendoz', 3512, 'Male', 'London')
insert into EmployeeFirstName values(4, 'John', 'Mendoz', 3123, 'Male', 'London1')
insert into EmployeeFirstName values(4, 'John', 'Mendoz', 3520, 'Male', 'London1')
--- enne ignore käsku oleks kõik kolm rida tagasi lükatud, aga
--- nüüd läks keskmine rida läbi kuna linna nimi oli unikaalne

--- view on salvestatud SQL-i päring. Saab käsitleda ka virtuaalse tabelina

select FirstName, Salary, Gender, DepartmentFirstName
from Employees
join Department
on Employees.DepartmentId = Department.Id

--- loome view
create view vEmployeesByDepartment
as
   select FirstName, Salary, Gender, DepartmentFirstName
   from Employees
   join Department
on Employees.DepartmentId = Department.Id

Select * from vEmployeesByDepartment

-- view ei salvesta andmeid vaikimisi
-- seda tasub võtta, kui salvestatud virtuaalse tabelina

-- milleks vaja:
-- saab kasutada andmebaasi skeemi keerukuse lihtsustamiseks,
-- mitte IT-inimesele
-- piiratud ligipääs andmetele, ei näe kõiki veerge

--- teeme view, kus näeb ainult IT-Töötajaid
create view vITEmployeesInDepartment
as
select FirstName, Salary, Gender, DepartmentFirstName -- saab näidata teatud arv veerge
from Employees
join Department
on Employees.DepartmentId = Department.Id
where Department.DepartmentFirstName = 'IT'
-- seda päringut saab liigitada reataseme turvalisuse alla
-- tahan ainult IT inimesi nädidata

select * from vITEmployeesInDepartment

-- saab kasutada esitlemaks koondandmeid ja üksikasjalike andmeid
-- view, mis tagastab summeritud andmeid
create view vEmployeesCountByDepartment
as
select DepartmentFirstName, COUNT(Employees.Id) as TotalEmployyes
from Employees
join Department
on Employees.DepartmentId = Department.Id
group by DepartmentFirstName

select * from vEmployeesCountByDepartment

--- 17 tund

---nüüd uuendab ainult ühes reas olevad osakonnad ära

update Employees set FirstName = 'Johny', Gender = 'Female', DepartmentId = '3'
where Id = 1

select * from Employees

--- kustutamisega tekib probleem, kas tahad kustutada lihtsalt ühte isikut või
--- osakonna all olevat osakonna nimetus
delete from Employees where Id in (1, 2)
select * from Employees

-- kustutamise trigger
create trigger tr_Employees_InsteadOfDelete on Employees
instead of delete
as begin
--- joini kood, mis on kiirem võrreldes alampäringuga
delete Employees
from Employees
join deleted
on Employees.Id = delted.Id

--- alampäringu versioon
delete from Employees
where Id int (select Id from deleted)
end

select * from Department
select * from Employees

insert into Employees values (1, 'John', 1000, 'Male', 3)
insert into Employees values (2, 'Mike', 3000, 'Male', 2)

--- päritud andmed ja CTE e common table expression sql-s

create view vEmployees
as
select Department, DepartmentId, COUNT(*) as TotalEmployees
from EmployeesTrigger
join DepartmentTrigger
on EmployeeTrigger.DepartmentId = DepartmentTrigger.Department
group by Department, DepartmentId

-- vaatame tulemust
select * from Employees
---teine versioon, aga näitab neid osakondasid, kus on kaks voi rohkem tootajat
select Department, Employees from EmployeeCount
where TotalEmployees >= 2

--- 18 tund

--- sama tulemuse tabeli muutujaga
--- eelis: saab saata parameetrina
--- seda ei genereerita mälus, vaid temptable-s

declare @tblEmployeeCount table
(DeptFirstName nvarchar(20), DepartmentId int, TotalEmployees int)
insert @tblEmployeeCount
select Department, DepartmentId, COUNT(*) as TotalEmployees
from tblEmployeeTrigger
join tblDepartmentTrigger
on tblEmployeeTrigger.DepartmentId = tblDepartmentTrigger.DepartmentId
group by Department, DepartmentId

select Department, TotalEmployees from #TempEmployeeCount
where TotalEmployees >=2

--- päritud tabelid
--- kõik sulgude sees on p'ritud tabel

select Department, TotalEmployees
from
(
select Department, DepartmentId, COUNT(*) as TotalEmployees
from tblEmployeeTrigger
on tblEmployeeTrigger.DepartmentId = tblDepartmentTrigger.DepartmentId
group by Department, DepartmentId
)
as EmployeeCount
where TotalEmployees >=1

--- CTE kasutamine
--- sulgude sees nagu table, esimeses reas on CTE määratlus
--- see on nagu temptable ja päritud tabel
--- seda ei saa säilitada kuskil ja kestab ainult päringu raames
with EmployeeCount(Department, DepartmentId, TotalEmployees)
as
(
select Department, DeparmentId, COUNT(*) as TotalEmployees
from tblEmployeeTrigger
join tblDepartmentTrigger
on tblEmployeeTrigger.DepartmentId = tblDepartmentTrigger.DepartmentId
group by Department, DepartmentId
)
select Department, TotalEmployees
from EmployeeCount
where TotalEmployees >= 2

--- 20 tund

with EmployeesByDepartment
as
(
select Id, FirstName, Gender, Department
from tblEmployeeTrigger
join tblDepartmentTrigger
on tblEmployeeTrigger.DepartmentId = tblDepartmentTrigger.DeptId
)
update EmployeesByDepartment set DeptFirstName = 'IT' where Id = 1

select * from tblDepartmentTrigger
select * from tblEmployeeTrigger

--- loome uue objekti
create table tblEmployeeCTE
(
EmployeeId int Primary key,
FirstName nvarchar(20),
ManagerId int
)

Insert into tblEmployeeCTE values (1, 'Tom', 2)
Insert into tblEmployeeCTE values (2, 'Josh', null)
Insert into tblEmployeeCTE values (3, 'Mike', 2)
Insert into tblEmployeeCTE values (4, 'John', 3)
Insert into tblEmployeeCTE values (5, 'Pam', 1)
Insert into tblEmployeeCTE values (6, 'Mary', 3)
Insert into tblEmployeeCTE values (7, 'James', 1)
Insert into tblEmployeeCTE values (8, 'Sam', 5)
Insert into tblEmployeeCTE values (9, 'Simon', 1)

-- lihtne self join
select Employees.FirstName as [Manager FirstName],
ISNULL(Manager.FirstName, 'Super Boss') as [Manager FirstName]
from tblEmployeeCTE Employees
left join tblEmployeeCTE mManager
on Employee.ManagerId = Manager.EmployeeId

--- CTE
with EmployeeCTE (EmployeeId, FirstName, ManagerId, [Level])

as
(
select EmployeeId, FirstName, ManagerId, 1
from tblEmployeeCTE
where ManagerId is null

union all

select tblEmployeeCTE.EmployeeId, tblEmployeeCTE.FirstName,
tblEmployeeCTE.ManagerId, EmployeeCTE.[Level] + 1
from tblEmployeeCTE
join EmployeeCTE
on tblEmployeeCTE.ManagerId = EmployeeCTE.EmployeeId
)
select * from EmployeeCTE
seleect EmpCTE.FirstName as Employee, ISNULL(MgrCTE.FirstName, 'Super Boss') as Manager,
EmpCTE.[Level]
from EmployeeCTE EmpCTE
left join EmployeeCTE MgrCTE
on EmpCTE.ManagerId = MgrCTE.EmployeeId


--- pivot operator

create table tblProductSales
(
SalesAgent nvarchar(20),
SalesCountry nvarchar(20),
SalesAmount int
)

Insert into tblProductSales values('Tom', 'UK', 200)
Insert into tblProductSales values('John', 'US', 180)
Insert into tblProductSales values('John', 'UK' 260)
Insert into tblProductSales values('David', 'India', 450)
Insert into tblProductSales values('Tom', 'India', 350)
Insert into tblProductSales values('John', 'UK', 230)
Insert into tblProductSales values('David', 'UK', 400)
Insert into tblProductSales values('Tom', 'India', 320)
Insert into tblProductSales values('Tom', 'UK', 660)
Insert into tblProductSales values('John', 'USA', 430)
Insert into tblProductSales values('Tom', 'UK', 230)
Insert into tblProductSales values('David', 'India', 280)

select * from tblProductSales

select SalesCountry, SalesAgent, SUM(SalesAmount) as Total
from tblProductSales
group by SalesCountry, SalesAgent
order by SalesCountry, SalesAgent

select SalesAgent, India, US, UK
from tblProductSales
pivot
(
SUM(SalesAmount) for SalesCountry in ([India],[US],[UK])
)
As PivotTabel

select SalesAgent, IndianCustomers, US, UK
from
(
sekect SalesAgent, SalesCountry, SalesAmount from tblProductSales
)
as SourceTable pivot
(
SUM(SalesAmount) for SalesCountry in (India, US, UK)
)

---inserted trigger
select * from Department

update Department set DepartmentFirstName = 'asd' where Id = 3

create view vEmployeeDetails
as
select Employees.Id, FirstName, Gender, DepartmentId
from Employees
join Department
on Employees.DepartmentId = Department.Id

select * from vEmployeeDetails

create trigger tr_vEmployeeDetails_InsertOfInsert
on vEmployeeDetails
instead of insert
as
begin

declare @DeptId int

-- vaatab, kas on olemas õiget DepartmentId
-- vastavas päringus
select @DeptId = DeptId -- kui keegi peaks mingi suvalise osakonnanime panema, siis vastus on null
from Department
join inserted
on inserted.DepartmentFirstName = Department.DepartmentFirstName

--kui departmentId on null, siis annab veateate ja lõpetab tegevuse
if(@DeptId is null) --kui vastus on null, siis annab alloleva vastuse
begin
raiserror('Invalid Department FirstName. Statement terminated', 16, 1)
return
end

--kui osakonna nimetus on korrektne
insert into Employees(Id, FirstName, Gender, DepartmentId)
select Id, FirstName, Gender, @DeptId
from inserted
end

select * from EmployeeAudit
select * from Employees
select * from Department

insert into vEmployeeDetails values(12, 'asd', 'Female', 'IT')

delete from Employees where Id = 12;

--ei saa andmete uuendust teha kuna mõjutab mitut tabelit korraga
update vEmployeeDetails set FirstName = 'Johny', DepartmentFirstName = 'IT' where Id = 1
select * from Department

-- loome triggeri
create trigger tr_vEmployeeDetails_InsteadOfUpdate
as vEmployeeDetails
instead of update
as begin
-- kui EmployeeId on uuendatud
if(update(Id))
begin
raiserror('Id cannot be changed', 16, 1)
return
end

--kui Departmentname on uuendatud
if(UPDATE(Departmentname))
begin
declare @DeptId int

select @DeptId = DeptId
from Department
join inserted
on inserted.DepartmentName = Department.DepartmentName

if(@DeptId is null)
begin
raiserror('Invalid Department Name', 16, 1)
return
end

update Employees set DepartmentId = @DeptId
from inserted
join Employees
on Employees.Id = inserted.Id
end

--kui Gender vereust on andmed uuendatud
if(UPDATE(Gender))
begin
update Employees set Gender = inserted.Gender
from inserted
join Employees
on Employees.Id = inserted.Id
end

-- kui name veerus on muudetud andmeid
if(UPDATE(FirstName))
begin
update Employees set FirstName = inserted.FirstName
from inserted
join Employees
on Employees.Id = inserted.id
end
end

update Employees set FirstName = 'John', Gender = 'Female', DepartmentId = 3
where Id = 1

select * from vEmployeeDetails
select * from Employees
select * from Department

-- delete trigger

create view vEmployeeCount
as
select DepartmentName, DepartmentId, COUNT(*) as TotalEmployees
from Employees
join Department
on Employees.DepartmentId = Department.Id
group by DepartmentName, DeaprtmentId

select * from vEmployeeCount

-- näitab, kus on rohkem, kui kaks töötajat
select DepartmentName, TotalEmployees from vEmployeeCount
where TotalEmployees >= 2

--temp e ajutine tabeli loomine ja siis inf kätte saamine
select DepartmentName, Department.Id, COUNT(*) as TotalEmployees
into #TempEmployeeCount
from Employees
join Department
on Employees.DepartmentId = Department.Id
group by DepartmentName, Department.Id

select * from #TotalEmployeeCount

--tabeli päring
select Departmentname, TotalEmployees
from #TempEmployeeCount
where TotalEmployees >= 2

--kustutamine temptabeli
drop table #TempEmployeeCount

declare @EmployeeCount
table(DepartmentName nvarchar(20), DepartmentId int, TotalEmployees int)
insert @EmployeeCount
select DepartmentName, DepartmentId, COUNT(*) as TotalEmployees
from Employees
join Department
on Employees.DepartmentId = Department.Id
group by DepartmentName, Department.Id


select DepartmentName, TotalEmployees
from @EmployeeCount
where TotalEmployees >= 2
-- päring lõppeb

-- sulgudes koondame kõik kokku ja võtame
-- ainult esimese rea SELECT-i järel oleva kokku
select DepartmentName, TotalEmployees
from
	(
		select DepartmentName, DepartmentId, count(*) as TotalEmployees
		from Employees
		join Department
		on Employees.DepartmentId = Department.Id
		group by DepartmentName, DepartmentId
	)
as EmployeeCount
where TotalEmployees >= 2

-- CTE e common table expression ja on sarnane tuletatud tabelile ja
-- ei ole talletatad objektile ja kestab päringu jooksul
-- tegemise on nagu temp tabeliga

with EmployeeCount(DepartmentName, DepartmentId, TotalEmployees)
as
	(
		select DepartmentName, DepartmentId, count(*) as TotalEmployees
		from Employees
		join Department
		on Employees.DepartmentId = Department.Id
		group by DepartmentName, DepartmentId
	)
select DepartmentName, TotalEmployees
from EmployeeCount
where TotalEmployees >= 2


select * from Employees

with Employees_Name_Gender
as
(
select Id, Firstname, Gender from Employees
)
update Employees_Name_Gender set Gender = 'Male' where Id = 0



with EmployeeCount(DepartmentId, TotalEmployees)
as
	(
		select DepartmentId, count(*) as TotalEmployees
		from Employees
		group by DepartmentId		 
	)
select DepartmentName, TotalEmployees
from Department
join EmployeeCount
on Department.id = EmployeeCount.DepartmentId
order by TotalEmployees

--- saab kasutada rohkem kui ühte CTE-d, aga peab komadega eraldama
with EmployeesCountBy_Payroll_IT_Dept(DepartmentName, Total)
as
	(
		select DepartmentName, count(Employees.Id) as TotalEmployees
		from Employees
		join Department
		on Employees.DepartmentId = Department.Id
		where DepartmentName in ('Payroll', 'IT')
		group by DepartmentName
	),
EmployeesCountBy_HR_Admin_Dept(DepartmentName, Total)
as
	(
		select DepartmentName, count(Employees.Id) as TotalEmployees
		from Employees
		join Department
		on Employees.DepartmentId = Department.Id
		where DepartmentName in ('HR', 'ADMIN')
		group by DepartmentName
	)
select * from EmployeesCountBy_Payroll_IT_Dept
union
select * from EmployeesCountBy_HR_Admin_Dept


--- Updatable CTE
select * from Employees;

--- saab muuta Gender veerus olevat väärtust
with EmployeesByDepartment
as
(
	Select Employees.Id, FirstName, Gender, DepartmentName
	from Employees
	join Department
	on Department.Id = Employees.DepartmentId
)
update EmployeeByDepartment set Gender = 'asd' where id = 1

select * from Employees

--- kuvad andmed selliselt, et nr asemel on osakonna nimed
--- CTE kahe baastabeli põhjal
with EmployeesByDepartment
as
(
	select Employees.Id, Firstname, Gender, DepartmentName
	from Employees
	join Department
	on Department.Id = Employees.DepartmentId
)
select * from EmployeesByDepartment


--- muudame Johni tagasi male pealeSS
with EmployeesByDepartment
as
(
	Select Employees.Id, FirstName, Gender, DepartmentName
	from Employees
	join Department
	on Department.Id = Employees.DepartmentId
)
update EmployeeByDepartment set Gender = 'male' where id = 1

-- tahame kahte baastabelit muuta
-- aga ei saa e ainult üks baastabel korraga
with EmployeesByDepartment
as
(
	Select Employees.Id, FirstName, Gender, DepartmentName
	from Employees
	join Department
	on Department.Id = Employees.DepartmentId
)
update EmployeeByDepartment set Gender = 'male', DepartmentName = 'IT' where id = 1


-- recursive CTE

create table Employee
(
EmployeeId int primary key,
Name nvarchar(20),
ManagerId int
)

insert into Employee values
(1, 'Tom', 2),
(2, 'Josh', NULL),
(3 ,'Mike', 2),
(4, 'John', 3),
(5, 'Pam', 1),
(6, 'Mary', 3),
(7, 'James', 1),
(8,'Sam', 5),
(9, 'Simon', 1)


select emp.Name as [Employee Name],
isnull(Manager.Name, 'Super Boss') as [Manager Name]
from employee emp
left join Employee Manager
on emp.ManagerId = Manager.EmployeeId


--- koht, kus tablis on null, sinna super boss
--- CTE tabel on ainult paringu ajaks moeldud tabel

with
	EmployeeCTE (EmployeeId, Name, ManagerId, [level])
	as
	(
		select EmployeeId, Name, ManagerId, 1
		from Employee
		where ManagerId is null

		union all

		select Employee.EmployeeId, Employee.Name, 
		Employee.ManagerId, EmployeeCTE.[level] + 1
		from Employee
		join EmployeeCTE
		on Employee.ManagerId = EmployeeCTE.EmployeeId
	)
select EmpCTE.Name as Employee, isnull(MgrCTE.Name, 'Super Boss') as Manager,
EmpCTE.[level]
from EmployeeCTE EmpCTE
left join EmployeeCTE MgrCTE
on EmpCTE.ManagerId = MgrCTE.EmployeeId

--- kõigile annab department tabelis ühe numbriga juurde ja järjestab employee
--- tabelis olevad isikud ära.

--- kokkuvõte CTEst
--- 1. kui CTE baseerub	ühel tabelil, siis uuendus töötab
--- 2. kui CTE baeerub mitmel tabelil, siis tuleb veateade
--- 3. kui CTE baseerub mitmel tabelil ja tahame muuta ainult ühte tabelit, siis uuendus saab tehtud

--- PIVOT tabel

create table ProductSales
(
SalesAgent nvarchar(50),
SalesCountry nvarchar(50),
SalesAmount int
)

insert into ProductSales values
('TOM', 'UK', 200),
('JOHN', 'US', 180),
('JOHN', 'UK', 260),
('DAVID', 'India', 450),
('TOM', 'India', 350),

('DAVID', 'US', 200),
('TOM', 'US', 130),
('JOHN', 'INDIA', 540),
('JOHN', 'UK', 120),
('DAVID', 'UK', 220),

('JOHN', 'US', 420),
('DAVID', 'US', 320),
('TOM', 'US', 340),
('TOM', 'UK', 660),
('JOHN', 'India', 430),

('DAVID', 'INDIA', 230),
('DAVID', 'INDIA', 280),
('TOM', 'UK', 480),
('DAVID', 'UK',360),
('TOM', 'UK', 140)


select SalesCountry, SalesAgent, SUM(SalesAmount)
as Total
From ProductSales
group by SalesCountry, SalesAgent
order by SalesCountry, SalesAgent



--- pivot näide
select SalesAgent, India, US, UK
from ProductSales
pivot
(
	sum(SalesAmount) for SalesCountry in ([India], [US], [UK])
)
as PivotTable

-- päring muudab unikaalsete veergude väärtust (INDIA, US ja UK)
-- salescountry veerus omaette veergudeks koos veergude SalesAmount liitmisega

create table ProductWithId
(
	Id int primary key,
	SalesAgent nvarchar(50),
	SalesCountry nvarchar(50),
	SalesAmount int
)


insert into ProductWithId values
(1, 'TOM', 'UK', 200),
(2, 'JOHN', 'US', 180),
(3, 'JOHN', 'UK', 260),
(4, 'DAVID', 'India', 450),
(5, 'TOM', 'India', 350),

(5, 'DAVID', 'US', 200),
(6, 'TOM', 'US', 130),
(7, 'JOHN', 'INDIA', 540),
(8, 'JOHN', 'UK', 120),
(9, 'DAVID', 'UK', 220),

(10, 'JOHN', 'US', 420),
(11, 'DAVID', 'US', 320),
(12, 'TOM', 'US', 340),
(13, 'TOM', 'UK', 660),
(14, 'JOHN', 'India', 430),

(15, 'DAVID', 'INDIA', 230),
(16, 'DAVID', 'INDIA', 280),
(17, 'TOM', 'UK', 480),
(18, 'DAVID', 'UK',360),
(19, 'TOM', 'UK', 140)


select SalesAgent, India, US, UK
from ProductWithId
pivot
(
	sum(SalesAmount) for SalesCountry in ([India], [US], [UK])
)
as PivotTable
--- tulemuseks on ID veeru olemasolu tabelis
--- ja mid voetakse arvess pooramise ja grupeerimise jargi

select Id, SalesAgent, India, US, UK
from
(
	select Id, SalesAgent, SalesCountry, SalesAmount
	from ProductWithId
)
as SournceTable
pivot
(
	sum(SalesAmount) for SalesCountry in ([India], [US], [UK])
)
as PivotTable


--- merge
--- tutvustati aastal 2008, mis lubab teha sisestamist,
--- uuendamist ja kustutamist
--- ei pea kasutama mitut käsku

--- merge puhul peab alati olema vähemalt kaks tabelit
--- 1. algallika tabel ehk source table
--- 2. sihtmärk tabel ehk target table


--- ühendab sihttabeli lähtetabliga ja kasutab mõlemas
--- tabelis ühist veergu
--- koodinäide:
merge [TARGET] as T
using [SOURCE] as S
	on [JOIN_CONDITIONS]
when matched then
	[UPDATE_STATEMENT]
when not matched by target then
	[INSERT_STATEMENT]
when not matched by source then
	[DELETE STATEMENT]


create table StudentSource
(
Id int primary key,
Name nvarchar(20)
)

insert into StudentSource Values (1, 'Mike')
insert into StudentSource Values (2, 'Sara')

create table StudentTarget
(
Id int primary key,
Name nvarchar(20)
)

insert into StudentSource Values (1, 'Mike M')
insert into StudentSource Values (3, 'John')


--- 1. Kui leitakse klappiv rida, siis StudentTarget
--- tabel on uuendatud
--- 2. kui  read on StundentSource tabelis olemas,
--- aga neid ei ole studentTarget-s,
--- puuduolevad read sisestatalse
--- 3. kui read on olemas StundentTarget-s, aga mitte
--- tabelis read kustutakse ära


merge StudentTarget as T
using StudentSource as S
on T.Id = S.Id
when matched then
	update set T.Name = S.Name
when not matched by target then
	insert (Id, Name) values(S.Id, S.Name)
	when not matched by source then
	delete;

select * from StundentTarget
select * from studentSource

-- tabeli sisu tühjaks
truncate table StudentTarget
Truncate Table StudentSource

insert into StudentSource Values (1, 'Mike')
insert into StudentSource Values (2, 'Sara')

insert into StudentSource Values (1, 'Mike M')
insert into StudentSource Values (3, 'John')


merge studentTarget as T
Using studentSource as S
on T.Id = S.Id
when matched then
	update set T.Name = S.Name
when not matched by target then
	insert (Id, Name) Values(S.Id, S.Name);
go

truncate table StudentTarget
Truncate Table StudentSource

--- Transaction-d
--- mis see on?
--- on ruhma kaske, mis muudavad DB-s salestatuid andmeid.
-- tehingut kasitletakse
--- ühe tööüksusena. Kas kõik Käsud õnnestuvad või mitte.
--- Kui üks tehing sellest ebaõnnestub
--- siis kõik juba muudetud andmed muudetakse tagasi

create table Account
(
Id int primary key,
AccountName nvarchar(25),
balance int
)

insert into account Values(1, 'Mark', 1000)
insert into account Values(2, 'Mary', 1000)

begin try
	begin transaction
		update Account set balance = balance - 100 where Id = 1
		update Account set balance = balance + 100 where Id = 2
	commit transaction
	print 'Transaction commited'
end try
begin catch
	rollback transaction
	print 'Trans rolled back'
end catch

select * from Account


--- Mõned levinumad probleemid:
--- 1. Dirty read e must lugemine
--- 2. Lost updates e kadunud uuendused
--- 3. nonreapeatable reads ehk koramatud lugemised
--- 4. phantom read e fantoom lugemine

--- kõik eelnevad probeemid lahendaks ära, kui lubaksite igal ajal
--- korraga ühel kasutajal ühe tehingu teha. Selle tulemusel kõik tehingud
--- satuvad järjekorda ja neil võib tekkida vajadus kaua oodata, enne
--- kui võimalus tehingut teha saabub.

--- kui lubada samaaegselt koik tehingud ära teha,
--- siis see omakorda tekitab probleeme
--- probleemi lahendamiseks pakub MSSQL server erinevaid
--- tehinguisolatsiooni tasemeid,
--- et tasakaalustada samaaegsete andemete CRUD(create, read, update ja delete) probleeme:

--- 1. read uncommited e lugemine ei ole teostatud
--- 2. read commited e lugemine tehtud
--- 3. repeatable read e korduv lugemine
--- 4. snapshot e kuvatõmmis
--- 5. serializable e serialiseerimine


--- igale juhtumile tuleb läheneda juhtumipõhiliselt ja
--- mida vähem valet lugemist tuleb, seda aeglasem
