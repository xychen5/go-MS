create database CXY;
use CXY;
create table TEACHER
(
    TID int primary key,
	TNAME char(30),
    TPASS char(30)
);

create table LESSON
(
    LID int primary key,
	LNAME char(30)
);

-- 考试表,由老师来插入 TE means te(st)， 老师的id和考试的id就可以唯一确定一次考试
create table TEST
(
    TEID int ,
	LID int ,
	TEW float,
	TENAME char(30),
    primary key(LID, TEID),
    foreign key(LID) references LESSON(LID)
);

create table STU
(
    SID int primary key,
	SNAME char(30),
    SPASS char(30)
);

-- 这里的教课表是dbo干的事情
create table TEACH
(
    TID int,
    LID int,
    primary key(TID, LID),
    foreign key(TID) references TEACHER(TID),
    foreign key(LID) references LESSON(LID)
);

--  这里的成绩为部分成绩，这是参加考试表
create table TAKET
(
    SID int,
    LID int,
	TEID int,
	PSCORE float default(0),  -- part score
	primary key(SID, LID, TEID),
    foreign key(SID) references STU(SID),
    foreign key(LID, TEID) references TEST(LID, TEID)
);

-- 注意，这里的takelesson中，没有告诉我的老师是哪个，所以需要加上一个老师
create table TAKEL 
(
    SID int,
	TID int,
	LID int,
    SCORE float default(0), -- total score
    primary key(SID, LID, TID),
    foreign key(TID) references TEACHER(TID),
    foreign key(SID) references STU(SID),
    foreign key(LID) references LESSON(LID)
);

-- 插入教师信息
insert into TEACHER (TID, TNAME, TPASS) values
    (1, "chen1", "1"),
    (2, "chen2", "1"),
    (3, "chen3", "1")
;

-- 插入学生信息
insert into STU (SID, SNAME, SPASS) values
    (1, "s1", "1"),
    (2, "s2", "1"),
    (3, "s3", "1")
;
 
-- 插入课程信息
insert into LESSON (LID, LNAME) values

    (1,"DB"),
    (2,"ML"),
    (3,"GO")
;

-- 插入教授信息
insert into TEACH (TID, LID) values
    (1, 1),
	(1, 2),
    (1, 3),
    (2, 2),
    (3, 3)
;

-- 插入考试信息,这个是老师登陆以后作的插入, 3号老师教GO，所以让他安排两次考试作为已经有的例子alter
insert into TEST (TEID, LID, TEW, TENAME) values
    (3, 1, 0.5, "GO1"),  -- 3号课程 1st考试
    (3, 2, 0.5, "GO2")   -- 3号课程 2nd考试
;

-- 插入参加课程信息,这个是当学生选了课程以后自动有的，我们先弄一些
insert into TAKEL (SID, TID, LID, SCORE) values
    (1, 1, 1, 0),
    (2, 2, 2, 0)
;

-- 插入参加考试信息，这个表存在的意义是记录部分成绩，因为每个课程有很多考试，




