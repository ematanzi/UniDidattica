-- procedures for populating some of the tables


create or replace PROCEDURE PopulateStudent AS

-- definisco gli array con i valori casuali
    TYPE NameArray IS VARRAY(20) OF VARCHAR2(20);
    TYPE SurnameArray IS VARRAY(20) OF VARCHAR2(20);
    TYPE DeptArray IS VARRAY(5) OF VARCHAR2(30);

    StudentNames NameArray := NameArray('Carlo', 'Paolo', 'Giuseppe', 'Francesco', 'Antonio', 'Giulio', 'Piero', 'Alessandro', 'Luca', 'Andrea', 'Sara', 'Federica', 'Roberta', 'Lucia', 'Chiara', 'Martina', 'Michele', 'Michela', 'Fabio', 'Maria');
    StudentSurnames SurnameArray := SurnameArray('Esposito', 'Russo', 'Rossi', 'Ferrara', 'Banchi', 'Mari', 'Pipoli', 'Gobbi', 'De Angelis', 'Franco', 'Maio', 'Miccoli', 'De Luca', 'Ferrari', 'De Rossi', 'Lopez', 'Gallo', 'Verde', 'Raimondi', 'Cerri');
    DeptNames DeptArray := DeptArray('Informatica', 'Giurisprudenza', 'Medicina', 'Fisica', 'Lettere');

    RandomName NUMBER;
    RandomSurname NUMBER;
    RandomDept NUMBER;

BEGIN

	For i IN 1..200 LOOP
	RandomName := TRUNC(DBMS_RANDOM.VALUE(1, StudentNames.COUNT + 1));
	RandomSurname := TRUNC(DBMS_RANDOM.VALUE(1, StudentSurnames.COUNT + 1));
	RandomDept := TRUNC(DBMS_RANDOM.VALUE(1, DeptNames.COUNT + 1));

	INSERT INTO Student VALUES (
		StudentNames(RandomName),
		StudentSurnames(RandomSurname),
		dbms_random.string('U', 6),
		(SELECT ref(d) FROM Department d WHERE d.DeptName = Deptnames(RandomDept)),
		GenerateRandomEmail,
		dbms_random.string('U', 16),
		0
	);

	END LOOP;

END;
/




create or replace PROCEDURE PopulateMembers AS

-- definisco gli array con i valori casuali
    TYPE NameArray IS VARRAY(30) OF VARCHAR2(20);
    TYPE SurnameArray IS VARRAY(30) OF VARCHAR2(20);
    TYPE DeptArray IS VARRAY(5) OF VARCHAR2(30);
    TYPE TeachesArray IS VARRAY(2) OF CHAR(1);

    StudentNames NameArray := NameArray('Carlo', 'Paolo', 'Giuseppe', 'Francesco', 'Antonio', 'Giulio', 'Piero', 'Alessandro', 'Luca', 'Andrea', 'Sara', 'Federica', 'Roberta', 'Lucia', 'Chiara', 'Martina', 'Michele', 'Michela', 'Fabio', 'Maria', 'Ferdinando', 'Emanuele', 'Clara', 'Luigi', 'Eleonora', 'Antonella', 'Sergio', 'Lorenzo', 'Nicola', 'Sofia');
    StudentSurnames SurnameArray := SurnameArray('Esposito', 'Russo', 'Rossi', 'Ferrara', 'Banchi', 'Mari', 'Pipoli', 'Gobbi', 'De Angelis', 'Franco', 'Maio', 'Miccoli', 'De Luca', 'Ferrari', 'De Rossi', 'Lopez', 'Gallo', 'Verde', 'Raimondi', 'Cerri', 'Lo Russo', 'Dangelo', 'Neri', 'Draghi', 'Conte', 'Conti', 'Santi', 'Alberti', 'Pirlo', 'Totti');
    DeptNames DeptArray := DeptArray('Informatica', 'Giurisprudenza', 'Medicina', 'Fisica', 'Lettere'); 
    IsTeaching TeachesArray := TeachesArray('t', 'f');

    RandomName NUMBER;
    RandomSurname NUMBER;
    RandomDept NUMBER;
    RandomTeaches NUMBER;

BEGIN

	For i IN 1..70 LOOP
	RandomName := TRUNC(DBMS_RANDOM.VALUE(1, StudentNames.COUNT + 1));
	RandomSurname := TRUNC(DBMS_RANDOM.VALUE(1, StudentSurnames.COUNT + 1));
	RandomDept := TRUNC(DBMS_RANDOM.VALUE(1, DeptNames.COUNT + 1));
	RandomTeaches := TRUNC(DBMS_RANDOM.VALUE(1, isTeaching.COUNT + 1));

	INSERT INTO Member VALUES (
		StudentNames(RandomName),
		StudentSurnames(RandomSurname),
		dbms_random.string('U', 6),
		(SELECT ref(d) FROM Department d WHERE d.DeptName = Deptnames(RandomDept)),
		GenerateRandomMemberEmail,
		IsTeaching(RandomTeaches)
	);

	END LOOP;

END;
/

-- Inserts Tuitions for students enrolled in Intelligenza Artificiale course
create or replace PROCEDURE PopulateTuition AS

    RandomIndex NUMBER;
    StudentMatr MatriculationArrayType;

BEGIN
    GetMatriculationsInf(StudentMatr);

    FOR i IN 1..50 LOOP
        RandomIndex := TRUNC(DBMS_RANDOM.VALUE(1, StudentMatr.COUNT + 1));

        INSERT INTO Tuition (
            DegreeProgram,
            Student,
            Expiration,
            Amount,
            Paid
        )
        VALUES (
            (SELECT REF(d) FROM DegreeProgram d WHERE d.degreename = 'Intelligenza Artificiale'),
            (SELECT REF(s) FROM Student s WHERE s.Matriculation = StudentMatr(RandomIndex)), -- Ottieni REF dello studente
            TO_DATE('01-gen-2022', 'DD-MON-YYYY') + ROUND(DBMS_RANDOM.VALUE(0, SYSDATE - TO_DATE('01-gen-2022', 'DD-MON-YYYY'))),
            RandomAmount.NEXTVAL,
            'f'
        );
    END LOOP;

    COMMIT;

END;
/



-- Inserts tuitions for students enrolled in Chirurgia course
create or replace PROCEDURE PopulateTuitionMed AS

    RandomIndex NUMBER;
    StudentMatr MatriculationArrayType;

BEGIN
    GetMatriculationsMed(StudentMatr);

    FOR i IN 1..50 LOOP
        RandomIndex := TRUNC(DBMS_RANDOM.VALUE(1, StudentMatr.COUNT + 1));

        INSERT INTO Tuition (
            DegreeProgram,
            Student,
            Expiration,
            Amount,
            Paid
        )
        VALUES (
            (SELECT REF(d) FROM DegreeProgram d WHERE d.degreename = 'Chirurgia'),
            (SELECT REF(s) FROM Student s WHERE s.Matriculation = StudentMatr(RandomIndex)), -- Ottieni REF dello studente
            TO_DATE('01-gen-2022', 'DD-MON-YYYY') + ROUND(DBMS_RANDOM.VALUE(0, SYSDATE - TO_DATE('01-gen-2022', 'DD-MON-YYYY'))),
            RandomAmount.NEXTVAL,
            'f'
        );
    END LOOP;

    COMMIT;

END;
/
