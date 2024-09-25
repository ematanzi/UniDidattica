-- types creation

create or replace TYPE OfficeInfoType AS OBJECT
(
    City VARCHAR2(30),
    Address VARCHAR2(45),
    VoicemailEmail VARCHAR2(30)
);

create or replace TYPE DepartmentType AS OBJECT
(
	DeptName VARCHAR(30),
	Office OfficeInfoType
);

CREATE OR REPLACE TYPE PersonType AS OBJECT
(
	FirstName VARCHAR2(20),
	LastName VARCHAR2(20)
) NOT FINAL;

create or replace TYPE UniPersonType UNDER PersonType
(
	Matriculation CHAR(6),
	Department REF DepartmentType,
	email VARCHAR2(30)
) NOT FINAL;

create or replace TYPE StudentType UNDER UniPersonType
(
	IBAN CHAR(16),
	InternshipHours NUMBER
);

create or replace TYPE MemberType UNDER UniPersonType 
(
	Teaches CHAR(1)
);

create or replace TYPE ExtraActivityType AS OBJECT
(
	ActivityCode CHAR(6),
	ActivityName VARCHAR(30),
	Description VARCHAR(50)
);

create or replace TYPE EnrolledInExtraType AS OBJECT
(
	ExtraActivity REF ExtraActivityType,
	Student REF StudentType,
	EnrollDate DATE
);

create or replace TYPE DegreeProgramType AS OBJECT
(
	DegreeName VARCHAR(30),
	Department REF DepartmentType,
	RequiredCredits NUMBER,
	InternshipHours NUMBER
);

create or replace TYPE TuitionType AS OBJECT
(
	DegreeProgram REF DegreeProgramType,
	Student REF StudentType,
	Expiration DATE,
	Amount NUMBER,
	Paid CHAR(1)
);

create or replace TYPE AttendingType AS OBJECT
(
	Semester CHAR(1),
	AttendingYear CHAR(1)
);

CREATE OR REPLACE TYPE CourseType;

CREATE OR REPLACE CourseArrayType AS VARRAY(5) OF REF CourseType;

CREATE OR REPLACE TYPE CourseType AS OBJECT
(
	DegreeProgram REF DegreeProgramType,
	CourseCode CHAR(6),
	CourseTitle VARCHAR(30),
	Credits NUMBER,
	Teacher REF MemberType,
	AttendingInfo AttendingType,
	Prerequisites CourseArrayType,
);

create or replace TYPE EnrollmentType AS OBJECT 
(
	Student REF StudentType,
	Course REF CourseType,
	EnrollmentDate DATE,
	ExamPassed CHAR(1)
);

create or replace TYPE ExamType AS OBJECT
(
	Enroll REF EnrollmentType,
 	ExamDate DATE,
	Mark NUMBER,

	MEMBER FUNCTION CanBeAccepted RETURN CHAR
);

create or replace TYPE BODY ExamType AS
	MEMBER FUNCTION CanBeAccepted RETURN CHAR IS
    flag CHAR(1);
	BEGIN
		IF Mark > 17 THEN
			RETURN 't';
		ELSE
			RETURN 'f';
		END IF;
	END;
END;

create or replace TYPE AssignmentType AS OBJECT
(
	Enroll REF EnrollmentType,
	AssignmentDate DATE,
	Description CLOB,
	Mark NUMBER
);

create or replace TYPE SourceType AS OBJECT
(
	SourceName VARCHAR(30),
	Amount NUMBER
);

CREATE OR REPLACE TYPE SourceTableType AS TABLE OF SourceType;

CREATE OR REPLACE TYPE MemberArrayType AS VARRAY(5) OF REF MemberType;

CREATE OR REPLACE TYPE ResearchProjectType AS OBJECT
(
	Title VARCHAR(40),
	StartDate DATE,
	EndDate DATE,
	Sources SourceTableType,
	Members MemberArrayType,

	MEMBER FUNCTION ProjectDurationDays RETURN NUMBER
);

create or replace TYPE BODY ResearchProjectType AS
	MEMBER FUNCTION ProjectDurationDays RETURN NUMBER IS
	BEGIN
		IF StartDate IS NOT NULL AND EndDate IS NOT NULL THEN
			RETURN EndDate - StartDate;
		ELSE 
			RETURN NULL;
        END IF;
    END;
END;

CREATE OR REPLACE TYPE ExternalMemberArrayType AS VARRAY(5) OF REF PersonType;

create or replace TYPE PublicationType AS OBJECT
(
    	ResearchProject REF ResearchProjectType,
	PublicationName VARCHAR(40),
	PublicationDate DATE,
	ExternalMember ExternalMemberArrayType
);

CREATE OR REPLACE TYPE StaffType AS OBJECT
(
    staffEmail VARCHAR(30),
    staffPassword VARCHAR(30),
    department REF DepartmentType
);

CREATE OR REPLACE TYPE StudentAccountType AS OBJECT
(
    Student REF StudentType,
    StudentPassword VARCHAR(30) 
);
























