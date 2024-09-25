-- Insertions in tables (to execute before the trigger definition, after procedures for population definition)

INSERT INTO Department
VALUES (
    DepartmentType(
        'Informatica', 
        OfficeInfoType('Bari', 'Via Orabona, 4', 'informatica@unidi.it') 
    )
);
INSERT INTO Department
VALUES (
    DepartmentType(
        'Giurisprudenza', 
        OfficeInfoType('Foggia', 'Via Galliani, 1', 'giurisprudenza@unidi.it') 
    )
);
INSERT INTO Department
VALUES (
    DepartmentType(
        'Medicina', 
        OfficeInfoType('Foggia', 'Piazza Cavour, 27', 'medicina@unidi.it') 
    )
);
INSERT INTO Department
VALUES (
    DepartmentType(
        'Fisica', 
        OfficeInfoType('Lecce', 'Corso Roma, 11', 'fisica@unidi.it') 
    )
);
INSERT INTO Department
VALUES (
    DepartmentType(
        'Lettere', 
        OfficeInfoType('Bari', 'Piazza Aldo Moro, 1', 'lettere@unidi.it') 
    )
);

-- The function allows to instantiate some tuples in Student automatically
BEGIN
    PopulateStudent;   
END;

--- The function allows to instantiate some tuples in Members automatically
BEGIN
    PopulateMembers;
	end

INSERT INTO extraactivity VALUES
(
    'PROG20',
    'Programmazione in Java',
    'Corso di livello base di Java'
);
INSERT INTO extraactivity VALUES
(
    'PROG21',
    'Programmazione in Java',
    'Corso di livello intermedio di Java'
);
INSERT INTO extraactivity VALUES
(
    'AMB100',
    'Inquinamento Ambientale',
    null
);
INSERT INTO extraactivity VALUES
(
    'AMB101',
    'Cambiamento Climatico',
    null
);
INSERT INTO extraactivity VALUES
(
    'AAAAAA',
    'Lingua Inglese - B1',
    null
);
INSERT INTO extraactivity VALUES
(
    'AAAAAB',
    'Lingua Inglese - B2',
    null
);
INSERT INTO extraactivity VALUES
(
    'AAAAAC',
    'Lingua Inglese - C1',
    null
);
INSERT INTO extraactivity VALUES
(
    'PROG10',
    'Programmazione in Python',
    'Corso di livello base di Python'
);
INSERT INTO extraactivity VALUES
(
    'PROG11',
    'Programmazione in Python',
    'Corso di livello avanzato in Python'
);


INSERT INTO DegreeProgram VALUES
(
	'Intelligenza Artificale',
	(SELECT REF(d) FROM Department d WHERE d.deptname = 'Informatica'),
	180,
	300
);
INSERT INTO DegreeProgram VALUES
(
	'Chirurgia',
	(SELECT REF(d) FROM Department d WHERE d.deptname = 'Medicina'),
	300,
	1800
);
INSERT INTO DegreeProgram VALUES
(
	'Criminologia',
	(SELECT REF(d) FROM Department d WHERE d.deptname = 'Giurisprudenza'),
	180,
	150
);
INSERT INTO DegreeProgram VALUES
(
	'Fisica quantistica',
	(SELECT REF(d) FROM Department d WHERE d.deptname = 'Fisica'),
	180,
	300
);
INSERT INTO DegreeProgram VALUES
(
	'Lettere Moderne',
	(SELECT REF(d) FROM Department d WHERE d.deptname = 'Lettere'),
	180,
	150
);

BEGIN
	PopulateTuition;
END;

BEGIN
	PopulateTuitionMed;
END;
	

INSERT INTO COURSE VALUES (
	(Select REF(d) FROM DegreeProgram d WHERE d.degreeName = 'Intelligenza Artificiale'),
	'CODE01',
	'Database',
	9,
	(SELECT REF(m) FROM Member m WHERE m.matriculation = 'KAPEJU'),
	AttendingType('1', '1'),
	CourseArrayType()
);
INSERT INTO COURSE VALUES (
	(Select REF(d) FROM DegreeProgram d WHERE d.degreeName = 'Intelligenza Artificiale'),
	'CODE21',
	'Programmazione I',
	12,
	(SELECT REF(m) FROM Member m WHERE m.matriculation = 'VSCCSC'),
	AttendingType('1', '1'),
	CourseArrayType()
);
INSERT INTO COURSE VALUES (
	(Select REF(d) FROM DegreeProgram d WHERE d.degreeName = 'Intelligenza Artificiale'),
	'CODE22',
	'Programmazione II',
	12,
	(SELECT REF(m) FROM Member m WHERE m.matriculation = 'KAPEJU'),
	AttendingType('1', '2'),
	CourseArrayType((SELECT REF(c) FROM Course c WHERE c.CourseCode = 'CODE21'))
);
INSERT INTO COURSE VALUES (
	(Select REF(d) FROM DegreeProgram d WHERE d.degreeName = 'Chirurgia'),
	'MEDZ10',
	'Anatomia I',
	12,
	(SELECT REF(m) FROM Member m WHERE m.matriculation = 'KQKTVF'),
	AttendingType('1', '1'),
	CourseArrayType()
);
INSERT INTO COURSE VALUES (
	(Select REF(d) FROM DegreeProgram d WHERE d.degreeName = 'Chirurgia'),
	'MEDZ20',
	'Anatomia II',
	9,
	(SELECT REF(m) FROM Member m WHERE m.matriculation = 'KQKTVF'),
	AttendingType('2', '1'),
	CourseArrayType((SELECT REF(c) FROM Course c WHERE c.CourseCode = 'MEDZ10'))
);
INSERT INTO COURSE VALUES (
	(Select REF(d) FROM DegreeProgram d WHERE d.degreeName = 'Chirurgia'),
	'MEDZ30',
	'Anatomia III',
	6,
	(SELECT REF(m) FROM Member m WHERE m.matriculation = 'KQKTVF'),
	AttendingType('1', '3'),
	CourseArrayType((SELECT REF(c) FROM Course c WHERE c.CourseCode = 'MEDZ10'), (SELECT REF(c) FROM Course c WHERE c.CourseCode = 'MEDZ20'))
);
INSERT INTO COURSE VALUES (
	(Select REF(d) FROM DegreeProgram d WHERE d.degreeName = 'Chirurgia'),
	'MEDZ55',
	'Cardiologia',
	6,
	(SELECT REF(m) FROM Member m WHERE m.matriculation = 'QSDGLP'),
	AttendingType('1', '2'),
	CourseArrayType()
);


INSERT INTO ENROLLMENT VALUES (
	(SELECT REF(s) FROM Student s WHERE s.matriculation = 'AZHSWF'),
	(SELECT REF(c) FROM Course c WHERE c.coursetitle = 'Programmazione I'),
	'15-lug-23',
	'f'
);
INSERT INTO ENROLLMENT VALUES (
	(SELECT REF(s) FROM Student s WHERE s.matriculation = 'CVQMIQ'),
	(SELECT REF(c) FROM Course c WHERE c.coursetitle = 'Programmazione I'),
	'15-lug-23',
	'f'
);
INSERT INTO ENROLLMENT VALUES (
	(SELECT REF(s) FROM Student s WHERE s.matriculation = 'FLXIGY'),
	(SELECT REF(c) FROM Course c WHERE c.coursetitle = 'Programmazione I'),
	'15-lug-23',
	'f'
);
INSERT INTO ENROLLMENT VALUES (
	(SELECT REF(s) FROM Student s WHERE s.matriculation = 'AZHSWF'),
	(SELECT REF(c) FROM Course c WHERE c.coursetitle = 'Database'),
	'15-lug-23',
	'f'
);
INSERT INTO ENROLLMENT VALUES (
	(SELECT REF(s) FROM Student s WHERE s.matriculation = 'CVQMIQ'),
	(SELECT REF(c) FROM Course c WHERE c.coursetitle = 'Database'),
	'15-lug-23',
	'f'
);
INSERT INTO ENROLLMENT VALUES (
	(SELECT REF(s) FROM Student s WHERE s.matriculation = 'BDMWPX'),
	(SELECT REF(c) FROM Course c WHERE c.coursetitle = 'Database'),
	'15-lug-23',
	'f'
);
INSERT INTO ENROLLMENT VALUES (
	(SELECT REF(s) FROM Student s WHERE s.matriculation = 'QDNMWH'),
	(SELECT REF(c) FROM Course c WHERE c.coursetitle = 'Anatomia I'),
	'30-AGO-23',
	'f'
);
INSERT INTO ENROLLMENT VALUES (
	(SELECT REF(s) FROM Student s WHERE s.matriculation = 'WLKXOM'),
	(SELECT REF(c) FROM Course c WHERE c.coursetitle = 'Anatomia I'),
	'30-AGO-23',
	'f'
);
INSERT INTO ENROLLMENT VALUES (
	(SELECT REF(s) FROM Student s WHERE s.matriculation = 'FETHZH'),
	(SELECT REF(c) FROM Course c WHERE c.coursetitle = 'Anatomia I'),
	'30-AGO-23',
	'f'
);


INSERT INTO EXAM VALUES (
	(SELECT REF(e) FROM Enrollment e WHERE Deref(e.student).matriculation = 'AZHSWF'
					   AND DEREF(e.course).coursetitle = 'Programmazione I'),
	'12-lug-24',
	14
);
INSERT INTO EXAM VALUES (
	(SELECT REF(e) FROM Enrollment e WHERE Deref(e.student).matriculation = 'AZHSWF'
					   AND DEREF(e.course).coursetitle = 'Programmazione I'),
	SYSDATE,
	28
);
INSERT INTO EXAM VALUES (
	(SELECT REF(e) FROM Enrollment e WHERE Deref(e.student).matriculation = 'CVQMIQ'
					   AND DEREF(e.course).coursetitle = 'Programmazione I'),
	SYSDATE,
	30
);
INSERT INTO EXAM VALUES (
	(SELECT REF(e) FROM Enrollment e WHERE Deref(e.student).matriculation = 'QDNMWH'
					   AND DEREF(e.course).coursetitle = 'Anatomia I'),
	SYSDATE,
	30
);
INSERT INTO EXAM VALUES (
	(SELECT REF(e) FROM Enrollment e WHERE Deref(e.student).matriculation = 'QDNMWH'
					   AND DEREF(e.course).coursetitle = 'Anatomia I'),
	'3-set-24',
	17
);



INSERT INTO ASSIGNMENT VALUES (
	(SELECT REF(e) FROM Enrollment e WHERE DEREF(e.student).matriculation = 'BDMWPX' AND DEREF(e.course).coursetitle = 'Database'),
	'20-ott-23',
	'Conceptual Design of DB',
	24
);
INSERT INTO ASSIGNMENT VALUES (
	(SELECT REF(e) FROM Enrollment e WHERE DEREF(e.student).matriculation = 'BDMWPX' AND DEREF(e.course).coursetitle = 'Database'),
	'20-ott-23',
	'Logical Design of DB',
	30
);
INSERT INTO ASSIGNMENT VALUES (
	(SELECT REF(e) FROM Enrollment e WHERE DEREF(e.student).matriculation = 'BDMWPX' AND DEREF(e.course).coursetitle = 'Database'),
	'20-ott-23',
	'Implementation of DB',
	31
);



INSERT INTO RESEARCHPROJECT VALUES (
	'AI in Astronomy',
	'01-gen-2024',
	'31-dic-2025',
	SourceTableType(SourceType('NASA', 7300000), SourceType('ESA', 1000000)),
	MemberArrayType(
        (SELECT REF(m) FROM Member m WHERE m.matriculation = 'VWLRZJ'), (SELECT REF(m) FROM Member m WHERE m.matriculation = 'LXBIAD')
    )
);
INSERT INTO RESEARCHPROJECT VALUES (
	'AI for the city safety',
	'01-mar-2024',
	'01-ott-2024',
	SourceTableType(SourceType('Comune di Bari', 12000), SourceType('Comune di Brindisi', 10000)),
	MemberArrayType(
        (SELECT REF(m) FROM Member m WHERE m.matriculation = 'VWLRZJ'), (SELECT REF(m) FROM Member m WHERE m.matriculation = 'WHYSOS'), (SELECT REF(m) FROM Member m WHERE m.matriculation = 'FKGPNP')
    )
);
INSERT INTO RESEARCHPROJECT VALUES (
	'Advanced therapies',
	'20-mar-23',
	'15-dic-24',
	SourceTableType(SourceType('Regione Puglia', 67000), SourceType('Ospedale di Foggia', 1)),
	MemberArrayType(
		(SELECT REF(m) FROM Member m WHERE m.matriculation = 'EXZYIX'),
		(SELECT REF(m) FROM Member m WHERE m.matriculation = 'TVSTQS'),
		(SELECT REF(m) FROM Member m WHERE m.matriculation = 'MRUVDU'),
		(SELECT REF(m) FROM Member m WHERE m.matriculation = 'RJOWKD')
	)
);

INSERT INTO PUBLICATION VALUES
(
	(SELECT REF(r) FROM ResearchProject r WHERE r.title = 'AI in Astronomy'),
	'Astronomy discoveries with AI',
	'15-giu-24',
	ExternalMemberArrayType(
        PersonType('Ivan', 'Dragovic'),
        PersonType('Stefan', 'Pavlovic'),
        PersonType('John', 'Davids')
    )
);
INSERT INTO PUBLICATION VALUES
(
	(SELECT REF(r) FROM ResearchProject r WHERE r.title = 'AI in Astronomy'),
	'Shuttle launch with AI',
	'15-set-24',
	ExternalMemberArrayType(
        PersonType('Emanuele', 'Tanzi'),
        PersonType('Marcus', 'Thuram'),
	PersonType('Jude', 'Bellingham'),
	PersonType('Alejandro', 'Garnacho')
    )
);
INSERT INTO PUBLICATION VALUES
(
	(SELECT REF(r) FROM ResearchProject r WHERE r.title = 'Advanced Therapies'),
	'Non invasive heart therapies',
	'11-dic-23',
	ExternalMemberArrayType(
        PersonType('Musashi', 'Miyamoto'),
        PersonType('Giancarlo', 'Gobbi'),
	PersonType('Stefano', 'Aprile'),
	PersonType('Alessandro', 'Maio')
    )
);

INSERT INTO STAFF VALUES
(
    'nino.creatore@staff.it',
    'ninocreatore',
    (SELECT REF(d) FROM department d WHERE d.deptname = 'Informatica')
);
INSERT INTO STAFF VALUES
(
    'sium.amogus@staff.it',
    'siumamogus',
    (SELECT REF(d) FROM department d WHERE d.deptname = 'Medicina')
);

INSERT INTO StudentAccount VALUES
(
    (SELECT REF(s) from Student s WHERE s.matriculation = 'AZHSWF'),
    'password123'
);
INSERT INTO StudentAccount VALUES
(
    (SELECT REF(s) from Student s WHERE s.matriculation = 'QDNMWH'),
    'password123'
);
