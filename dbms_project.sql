
CREATE DATABASE counselling_db;
USE counselling_db;

CREATE TABLE students (
  id INT AUTO_INCREMENT PRIMARY KEY,
  student_no VARCHAR(50) UNIQUE NOT NULL,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20),
  date_of_birth DATE,
  gender VARCHAR(20),
  department VARCHAR(100),
  enrollment_year SMALLINT,
  emergency_contact_name VARCHAR(100),
  emergency_contact_phone VARCHAR(20),
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE counsellors (
  id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20),
  specialization VARCHAR(100),
  is_available BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE appointments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  counsellor_id INT NOT NULL,
  scheduled_at TIMESTAMP NOT NULL,
  duration_minutes SMALLINT DEFAULT 60,
  appointment_type ENUM('in-person','online') DEFAULT 'in-person',
  status ENUM('pending','confirmed','cancelled','completed') DEFAULT 'pending',
  student_notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (student_id) REFERENCES students(id),
  FOREIGN KEY (counsellor_id) REFERENCES counsellors(id)
);

CREATE TABLE assessments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  assessment_type ENUM('PHQ-9','GAD-7','Wellbeing') NOT NULL,
  total_score SMALLINT,
  severity_level ENUM('Minimal','Mild','Moderate','Severe'),
  taken_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (student_id) REFERENCES students(id)
);

CREATE TABLE assessment_questions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  assessment_type VARCHAR(50) NOT NULL,
  order_no SMALLINT NOT NULL,
  question_text TEXT NOT NULL,
  response_type ENUM('scale','multiple-choice','yes-no') NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE assessment_responses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  assessment_id INT NOT NULL,
  question_id INT NOT NULL,
  response_value SMALLINT,
  response_text TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (assessment_id) REFERENCES assessments(id),
  FOREIGN KEY (question_id) REFERENCES assessment_questions(id)
);

CREATE TABLE sessions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  appointment_id INT,
  student_id INT NOT NULL,
  counsellor_id INT NOT NULL,
  session_date DATE NOT NULL,
  duration_minutes SMALLINT DEFAULT 60,
  session_notes TEXT,
  mood_rating SMALLINT CHECK (mood_rating BETWEEN 1 AND 10),
  follow_up_required BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (appointment_id) REFERENCES appointments(id),
  FOREIGN KEY (student_id) REFERENCES students(id),
  FOREIGN KEY (counsellor_id) REFERENCES counsellors(id)
);

CREATE TABLE crisis_alerts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  counsellor_id INT,
  alert_level ENUM('low','medium','high') NOT NULL,
  description TEXT,
  is_resolved BOOLEAN DEFAULT FALSE,
  resolved_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (student_id) REFERENCES students(id),
  FOREIGN KEY (counsellor_id) REFERENCES counsellors(id)
);

CREATE TABLE resources (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  description TEXT,
  category VARCHAR(100) NOT NULL,
  resource_type ENUM('article','video','hotline','app','other') NOT NULL,
  content_url VARCHAR(255),
  is_published BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE entry_logs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  entity_type VARCHAR(100) NOT NULL,
  entity_id INT NOT NULL,
  entity_name VARCHAR(100) NOT NULL,
  action VARCHAR(50) NOT NULL,
  data JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


START TRANSACTION;

-- 1) students
INSERT IGNORE INTO students (
  id, student_no, full_name, email, phone, date_of_birth, gender, department,
  enrollment_year, emergency_contact_name, emergency_contact_phone, is_active
)
VALUES
(9001,'STU9001','Aarav Mehta','aarav.mehta@university.edu','+91-9000000001','2003-02-14','Male','Computer Science',2022,'Raj Mehta','+91-8000000001',1),
(9002,'STU9002','Diya Nair','diya.nair@university.edu','+91-9000000002','2002-08-21','Female','Psychology',2021,'Latha Nair','+91-8000000002',1),
(9003,'STU9003','Rohan Singh','rohan.singh@university.edu','+91-9000000003','2004-01-09','Male','Mechanical',2023,'Amit Singh','+91-8000000003',1),
(9004,'STU9004','Ananya Iyer','ananya.iyer@university.edu','+91-9000000004','2003-06-01','Female','Electronics',2022,'Suresh Iyer','+91-8000000004',1),
(9005,'STU9005','Karan Patel','karan.patel@university.edu','+91-9000000005','2001-11-18','Male','Civil',2020,'Mina Patel','+91-8000000005',1),
(9006,'STU9006','Sneha Reddy','sneha.reddy@university.edu','+91-9000000006','2002-03-30','Female','Biotechnology',2021,'Ravi Reddy','+91-8000000006',1),
(9007,'STU9007','Vikram Joshi','vikram.joshi@university.edu','+91-9000000007','2003-10-12','Male','Mathematics',2022,'Neha Joshi','+91-8000000007',1),
(9008,'STU9008','Isha Sharma','isha.sharma@university.edu','+91-9000000008','2004-05-25','Female','Physics',2023,'Asha Sharma','+91-8000000008',1),
(9009,'STU9009','Aditya Rao','aditya.rao@university.edu','+91-9000000009','2002-12-03','Male','Economics',2021,'Kiran Rao','+91-8000000009',1),
(9010,'STU9010','Meera Das','meera.das@university.edu','+91-9000000010','2003-07-17','Female','English',2022,'Soma Das','+91-8000000010',1);

-- 2) counsellors
INSERT IGNORE INTO counsellors (id, full_name, email, phone, specialization, is_available)
VALUES
(9101,'Dr. Isha Verma','isha.verma@university.edu','+91-9111111101','Stress Management',1),
(9102,'Mr. Kunal Rao','kunal.rao@university.edu','+91-9111111102','Anxiety Support',1),
(9103,'Dr. Priya Menon','priya.menon@university.edu','+91-9111111103','Depression Care',1),
(9104,'Ms. Nidhi Kapoor','nidhi.kapoor@university.edu','+91-9111111104','Trauma Counselling',1),
(9105,'Dr. Arjun Sen','arjun.sen@university.edu','+91-9111111105','Sleep Disorders',1),
(9106,'Ms. Rhea Thomas','rhea.thomas@university.edu','+91-9111111106','Academic Burnout',1),
(9107,'Dr. Manav Jain','manav.jain@university.edu','+91-9111111107','Substance Misuse',1),
(9108,'Ms. Tara Bhat','tara.bhat@university.edu','+91-9111111108','Peer Conflict',1),
(9109,'Dr. Nikhil Paul','nikhil.paul@university.edu','+91-9111111109','Crisis Intervention',1),
(9110,'Ms. Aditi Kulkarni','aditi.kulkarni@university.edu','+91-9111111110','General Wellbeing',1);

-- 3) appointments
INSERT IGNORE INTO appointments (
  id, student_id, counsellor_id, scheduled_at, duration_minutes,
  appointment_type, status, student_notes
)
VALUES
(9201,9001,9101,DATE_ADD(NOW(), INTERVAL 1 DAY),60,'in-person','confirmed','Stress before exams'),
(9202,9002,9102,DATE_ADD(NOW(), INTERVAL 2 DAY),60,'online','pending','Sleep issues'),
(9203,9003,9103,DATE_ADD(NOW(), INTERVAL 3 DAY),45,'in-person','confirmed','Low motivation'),
(9204,9004,9104,DATE_ADD(NOW(), INTERVAL 4 DAY),60,'online','pending','Family pressure'),
(9205,9005,9105,DATE_ADD(NOW(), INTERVAL 5 DAY),60,'in-person','confirmed','Career uncertainty'),
(9206,9006,9106,DATE_ADD(NOW(), INTERVAL 6 DAY),45,'online','pending','Overthinking'),
(9207,9007,9107,DATE_ADD(NOW(), INTERVAL 7 DAY),60,'in-person','confirmed','Social anxiety'),
(9208,9008,9108,DATE_ADD(NOW(), INTERVAL 8 DAY),60,'online','pending','Isolation feelings'),
(9209,9009,9109,DATE_ADD(NOW(), INTERVAL 9 DAY),45,'in-person','confirmed','Panic episodes'),
(9210,9010,9110,DATE_ADD(NOW(), INTERVAL 10 DAY),60,'online','pending','General stress');

-- 4) sessions
INSERT IGNORE INTO sessions (
  id, appointment_id, student_id, counsellor_id, session_date,
  duration_minutes, session_notes, mood_rating, follow_up_required
)
VALUES
(9301,9201,9001,9101,DATE_SUB(CURDATE(), INTERVAL 10 DAY),60,'Discussed planning and routines.',6,1),
(9302,9202,9002,9102,DATE_SUB(CURDATE(), INTERVAL 9 DAY),60,'Breathing drills shared.',7,0),
(9303,9203,9003,9103,DATE_SUB(CURDATE(), INTERVAL 8 DAY),45,'Set achievable weekly goals.',5,1),
(9304,9204,9004,9104,DATE_SUB(CURDATE(), INTERVAL 7 DAY),60,'Talked through family dynamics.',6,1),
(9305,9205,9005,9105,DATE_SUB(CURDATE(), INTERVAL 6 DAY),60,'Sleep hygiene protocol started.',7,0),
(9306,9206,9006,9106,DATE_SUB(CURDATE(), INTERVAL 5 DAY),45,'Journaling exercise assigned.',6,1),
(9307,9207,9007,9107,DATE_SUB(CURDATE(), INTERVAL 4 DAY),60,'Coping strategy for triggers.',5,1),
(9308,9208,9008,9108,DATE_SUB(CURDATE(), INTERVAL 3 DAY),60,'Peer support group suggested.',7,0),
(9309,9209,9009,9109,DATE_SUB(CURDATE(), INTERVAL 2 DAY),45,'Grounding techniques practiced.',4,1),
(9310,9210,9010,9110,DATE_SUB(CURDATE(), INTERVAL 1 DAY),60,'Regular check-in; stable.',8,0);

-- (Rest tables same pattern — already safe)

COMMIT;
-- function of count of total appointments
DELIMITER $$

CREATE FUNCTION get_total_appointments(p_student_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT COUNT(*)
    INTO total
    FROM appointments
    WHERE student_id = p_student_id;

    RETURN total;
END$$

DELIMITER ;

-- risk level function

DELIMITER $$

CREATE FUNCTION get_risk_level(p_student_id INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE score INT;

    SELECT total_score
    INTO score
    FROM assessments
    WHERE student_id = p_student_id
    ORDER BY taken_at DESC
    LIMIT 1;

    IF score >= 15 THEN
        RETURN 'HIGH';
    ELSEIF score >= 10 THEN
        RETURN 'MEDIUM';
    ELSE
        RETURN 'LOW';
    END IF;

END$$

DELIMITER ;

-- procedures

DELIMITER $$

CREATE PROCEDURE add_student (
    IN p_student_no VARCHAR(50),
    IN p_name VARCHAR(100),
    IN p_email VARCHAR(100)
)
BEGIN
    INSERT INTO students (student_no, full_name, email)
    VALUES (p_student_no, p_name, p_email);
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE book_appointment (
    IN p_student_id INT,
    IN p_counsellor_id INT,
    IN p_date DATETIME,
    IN p_type VARCHAR(20)
)
BEGIN
    DECLARE availability BOOLEAN;

    -- Check counsellor availability
    SELECT is_available INTO availability
    FROM counsellors
    WHERE id = p_counsellor_id;

    IF availability = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Counsellor not available';
    END IF;

    INSERT INTO appointments (
        student_id, counsellor_id, scheduled_at, appointment_type, status
    )
    VALUES (
        p_student_id, p_counsellor_id, p_date, p_type, 'pending'
    );
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE update_appointment_status (
    IN p_appointment_id INT,
    IN p_status VARCHAR(20)
)
BEGIN
    UPDATE appointments
    SET status = p_status
    WHERE id = p_appointment_id;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE assign_available_counsellor (
    IN p_student_id INT
)
BEGIN
    DECLARE c_id INT;

    -- Get first available counsellor
    SELECT id INTO c_id
    FROM counsellors
    WHERE is_available = 1
    LIMIT 1;

    -- Book appointment automatically
    INSERT INTO appointments (
        student_id,
        counsellor_id,
        scheduled_at,
        status
    )
    VALUES (
        p_student_id,
        c_id,
        NOW(),
        'pending'
    );
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE get_student_history (
    IN p_student_id INT
)
BEGIN
    SELECT 
        s.full_name,
        a.scheduled_at,
        a.status,
        se.session_notes,
        se.mood_rating
    FROM students s
    LEFT JOIN appointments a ON s.id = a.student_id
    LEFT JOIN sessions se ON a.id = se.appointment_id
    WHERE s.id = p_student_id;
END$$

DELIMITER ;

-- triger add student
DELIMITER $$

CREATE TRIGGER trg_after_student_insert
AFTER INSERT ON students
FOR EACH ROW
BEGIN
    -- Log new student
    INSERT INTO entry_logs (
        entity_type, entity_id, entity_name, action, data
    )
    VALUES (
        'student',
        NEW.id,
        NEW.full_name,
        'created',
        JSON_OBJECT('email', NEW.email)
    );
END$$

DELIMITER ;

-- exception handling add student
DELIMITER $$

CREATE PROCEDURE add_student_safe (
    IN p_student_no VARCHAR(50),
    IN p_name VARCHAR(100),
    IN p_email VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'Error inserting student (maybe duplicate email)' AS msg;
    END;

    INSERT INTO students (student_no, full_name, email)
    VALUES (p_student_no, p_name, p_email);

    SELECT 'Student added successfully' AS msg;
END$$

DELIMITER ;


-- triger book appointment

DELIMITER $$

CREATE TRIGGER trg_before_appointment_insert
BEFORE INSERT ON appointments
FOR EACH ROW
BEGIN
    DECLARE cnt INT;

    -- Check if counsellor already has appointment at same time
    SELECT COUNT(*) INTO cnt
    FROM appointments
    WHERE counsellor_id = NEW.counsellor_id
      AND scheduled_at = NEW.scheduled_at;

    IF cnt > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Counsellor already booked at this time';
    END IF;
END$$

DELIMITER ;

-- cursor book appointment

DELIMITER $$

CREATE PROCEDURE list_upcoming_appointments()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE a_id INT;

    DECLARE cur CURSOR FOR
        SELECT id FROM appointments WHERE status = 'pending';

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO a_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT a_id AS Appointment_ID;

    END LOOP;

    CLOSE cur;
END$$

DELIMITER ;


-- triger update appointment status 
DELIMITER $$

CREATE TRIGGER trg_after_appointment_update
AFTER UPDATE ON appointments
FOR EACH ROW
BEGIN
    IF OLD.status <> NEW.status THEN
        INSERT INTO entry_logs (
            entity_type, entity_id, entity_name, action, data
        )
        VALUES (
            'appointment',
            NEW.id,
            CONCAT('Appointment_', NEW.id),
            'status_updated',
            JSON_OBJECT('old', OLD.status, 'new', NEW.status)
        );
    END IF;
END$$

DELIMITER ;

-- update appointment exception handling
DELIMITER $$

CREATE PROCEDURE update_status_safe (
    IN p_id INT,
    IN p_status VARCHAR(20)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'Error updating appointment status' AS msg;
    END;

    UPDATE appointments
    SET status = p_status
    WHERE id = p_id;

    SELECT 'Status updated successfully' AS msg;
END$$

DELIMITER ;

-- cursor assign counsellor
DELIMITER $$

CREATE PROCEDURE assign_counsellor_cursor (
    IN p_student_id INT
)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE c_id INT;

    DECLARE cur CURSOR FOR
        SELECT id FROM counsellors WHERE is_available = 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    FETCH cur INTO c_id;

    IF done = 0 THEN
        INSERT INTO appointments (
            student_id, counsellor_id, scheduled_at, status
        )
        VALUES (
            p_student_id, c_id, NOW(), 'pending'
        );
    END IF;

    CLOSE cur;
END$$

DELIMITER ;

-- triger assign counsellor
DELIMITER $$

CREATE TRIGGER trg_after_assign
AFTER INSERT ON appointments
FOR EACH ROW
BEGIN
    UPDATE counsellors
    SET is_available = 0
    WHERE id = NEW.counsellor_id;
END$$

DELIMITER ;

-- cursor get student history
DELIMITER $$

CREATE PROCEDURE student_history_cursor (
    IN p_student_id INT
)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE notes TEXT;

    DECLARE cur CURSOR FOR
        SELECT session_notes
        FROM sessions
        WHERE student_id = p_student_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO notes;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT notes AS Session_Notes;

    END LOOP;

    CLOSE cur;
END$$

DELIMITER ;

-- exception handling get student history
DELIMITER $$

CREATE PROCEDURE get_history_safe (
    IN p_student_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'Error fetching student history' AS msg;
    END;

    SELECT * FROM sessions
    WHERE student_id = p_student_id;
END$$

DELIMITER ;add_student
