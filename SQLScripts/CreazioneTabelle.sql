CREATE TABLE Department OF DepartmentType
(
	DeptName PRIMARY KEY
);

CREATE TABLE Student OF StudentType
(
	Matriculation PRIMARY KEY,
	FirstName NOT NULL,
	LastName NOT NULL,
	Department NOT NULL
);

CREATE TABLE Member OF MemberType
(
	Matriculation PRIMARY KEY,
	FirstName NOT NULL,
	LastName NOT NULL,
	Department NOT NULL
);

CREATE TABLE ExtraActivity OF ExtraActivityType
(
	ActivityCode PRIMARY KEY,
	ActivityName NOT NULL
);

CREATE TABLE EnrolledInExtra OF EnrolledInExtraType;

CREATE TABLE DegreeProgram OF DegreeProgramType
(
	DegreeName PRIMARY KEY,
	RequiredCredits NOT NULL,
	Department NOT NULL
);

CREATE TABLE Tuition OF TuitionType
(
	Amount NOT NULL,
	Paid NOT NULL
);

-- Table Creation

CREATE TABLE Course OF CourseType
(
	DegreeProgram NOT NULL,
	CourseCode PRIMARY KEY,
	CourseTitle NOT NULL,
	Credits NOT NULL
);

CREATE TABLE Exam OF ExamType
(
	Enroll NOT NULL,
	ExamDate NOT NULL,
	Mark NOT NULL
);

CREATE TABLE Enrollment OF EnrollmentType;

CREATE TABLE Assignment OF AssignmentType
(
	Enroll NOT NULL,
	AssignmentDate NOT NULL,
	Mark NOT NULL
);

CREATE TABLE ResearchProject OF ResearchProjectType
(
    Title PRIMARY KEY,
    StartDate NOT NULL,
    EndDate NOT NULL
)
NESTED TABLE Sources STORE AS SourceNT_TAB

CREATE TABLE Publication OF PublicationType
(
	PublicationName PRIMARY KEY,
	PublicationDate NOT NULL
);

CREATE TABLE Staff OF StaffType
(
    staffEmail PRIMARY KEY,
    staffPassword NOT NULL,
    department NOT NULL
);

CREATE TABLE StudentAccount OF StudentAccountType
(
    STUDENT NOT NULL,
    StudentPassword NOT NULL
);