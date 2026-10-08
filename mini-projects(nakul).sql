-- =========================================================================
-- MINI-PROJECT 1: STUDENT DATABASE MANAGEMENT SYSTEM
-- AUTHOR: [nakul]
-- DESCRIPTION: Standard College Infrastructure DB Architecture
-- =========================================================================

-- STEP 1: Pehle check karenge agar purana test database hai toh use clean karenge
DROP DATABASE IF EXISTS student_management_system;

-- Naya database khada karenge aur use active karenge
CREATE DATABASE student_management_system;
USE student_management_system;

-- STEP 2: Database Schema Architecture (Tables Structure)
-- 1. Departments Table (Sabu se basic metadata table)
CREATE TABLE departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL,
    hod_name VARCHAR(50)
);

-- 2. Students Table (Isme foreign key lagayi hai dept_id par tracking ke liye)
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    enroll_date DATE,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- 3. Courses Table (Syllabus database architecture)
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_title VARCHAR(100) NOT NULL,
    credits INT DEFAULT 3,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- 4. Enrollments Table (M:N Relationship break karne ke liye associative table)
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    grade CHAR(2),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- STEP 3: Real Looking Sample Indian College Data Ingestion
-- Departments entry
INSERT INTO departments (dept_name, hod_name) VALUES 
('Computer Science', 'Dr. AK Sharma'),
('Mechanical Engineering', 'Prof. RK Verma'),
('Electronics', 'Dr. S. K. Singh');

-- Students logs ingestion
INSERT INTO students (first_name, last_name, email, enroll_date, dept_id) VALUES 
('Rahul', 'Kumar', 'rahul.k@gmail.com', '2026-08-01', 1),
('Priya', 'Sharma', 'priya.s@yahoo.com', '2026-08-05', 1),
('Amit', 'Patel', 'amit.patel@gmail.com', '2026-08-10', 2),
('Sneha', 'Reddy', 'sneha.r@outlook.com', '2026-08-12', 3);

-- Academic courses mapping
INSERT INTO courses (course_title, credits, dept_id) VALUES 
('Database Management Systems', 4, 1),
('Data Structures', 4, 1),
('Thermodynamics', 3, 2),
('Digital Electronics', 3, 3);

-- Active enrollments & grade records allocation
INSERT INTO enrollments (student_id, course_id, grade) VALUES 
(1, 1, 'A'),
(1, 2, 'B'),
(2, 1, 'A'),
(3, 3, 'C');

-- STEP 4: Analytical Verification Reporting Queries (Internship Showcase)

-- Query A: Saare bacchon ki primary details unke active department ke sath link karna (INNER JOIN)
SELECT s.student_id, s.first_name, s.last_name, d.dept_name 
FROM students s
INNER JOIN departments d ON s.dept_id = d.dept_id;

-- Query B: Kis department me total kitne students currently load ho rakhe hain (GROUP BY & COUNT aggregation)
SELECT d.dept_name, COUNT(s.student_id) AS total_students
FROM departments d
LEFT JOIN students s ON d.dept_id = s.dept_id
GROUP BY d.dept_name;

-- Query C: DBMS course me 'A' grade laane wale honhaar bacchon ka data check karna (Multi-Table Join Filters)
SELECT s.first_name, s.last_name, c.course_title, e.grade
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_title = 'Database Management Systems' AND e.grade = 'A';  


-- =========================================================================
-- MINI-PROJECT 2: LIBRARY MANAGEMENT SYSTEM (BY ME FOR INTERNSHIP)
-- =========================================================================

-- Step 1: Naya Database banta hai yahan
CREATE DATABASE IF NOT EXISTS library_db;
USE library_system_db;

-- Step 2: Tables design karna
CREATE TABLE IF NOT EXISTS books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    author VARCHAR(50),
    isbn VARCHAR(20) UNIQUE,
    published_year INT,
    status VARCHAR(20) DEFAULT 'Available'
);

CREATE TABLE IF NOT EXISTS members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
    join_date DATE,
    membership_type VARCHAR(20) DEFAULT 'Standard'
);

CREATE TABLE IF NOT EXISTS loan_records (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    member_id INT,
    issue_date DATE,
    due_date DATE,
    return_date DATE NULL,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- Step 3: Genuin dummy data insert karna
INSERT INTO books (title, author, isbn, published_year) VALUES 
('The White Tiger', 'Aravind Adiga', '978-0143065401', 2008),
('Train to Pakistan', 'Khushwant Singh', '978-0143065883', 1956),
('Wings of Fire', 'APJ Abdul Kalam', '978-8173711466', 1999);

INSERT INTO members (full_name, join_date, membership_type) VALUES 
('Vikas Khanna', '2025-01-15', 'Premium'),
('Ananya Sen', '2025-03-22', 'Standard'),
('Rohan Das', '2025-05-10', 'Standard');

INSERT INTO loan_records (book_id, member_id, issue_date, due_date, return_date) VALUES 
(1, 1, '2026-09-01', '2026-09-15', '2026-09-12'),
(2, 2, '2026-09-10', '2026-09-24', NULL), -- Ye abhi tak return nahi hui hai
(3, 3, '2026-09-15', '2026-09-29', NULL);

-- Step 4: Library Checking Queries
-- Query 1: Un bacchon ke naam aur book titles jo abhi tak return nahi hui (JOIN with NULL check)
SELECT m.full_name, b.title, l.issue_date, l.due_date 
FROM loan_records l
JOIN members m ON l.member_id = m.member_id
JOIN books b ON l.book_id = b.book_id
WHERE l.return_date IS NULL;


-- =========================================================================
-- MINI-PROJECT 3: E-COMMERCE PLATFORM SALES ENGINE
-- =========================================================================

CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

-- Tables create karna
CREATE TABLE IF NOT EXISTS products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) NOT NULL,
    stock_qty INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    city VARCHAR(50),
    phone VARCHAR(15)
);

CREATE TABLE IF NOT EXISTS orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE IF NOT EXISTS order_details (
    detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Real items aur orders daalna
INSERT INTO products (product_name, category, price, stock_qty) VALUES 
('Boat Rockerz Headphones', 'Electronics', 1499.00, 50),
('Puma Running Shoes', 'Footwear', 2999.00, 30),
('Wildcraft Backpack', 'Accessories', 1200.00, 100);

INSERT INTO customers (customer_name, city, phone) VALUES 
('Deepak Sharma', 'Delhi', '9876543210'),
('Kriti Joshi', 'Mumbai', '8765432109'),
('Manish Nair', 'Bangalore', '7654321098');

-- Order summary data
INSERT INTO orders (customer_id, order_date, total_amount) VALUES 
(1, '2026-10-01', 1499.00),
(2, '2026-10-02', 4199.00);

-- Order details breakdown
INSERT INTO order_details (order_id, product_id, quantity, unit_price) VALUES 
(1, 1, 1, 1499.00), -- Deepak ne headphone liya
(2, 1, 1, 1499.00), -- Kriti ne headphone aur shoes dono liye
(2, 2, 1, 2999.00);

-- Revenue check queries
-- Query 1: Kis customer ne total kitne rupaye ki shopping kari hai (SUM & GROUP BY)
SELECT c.customer_name, SUM(o.total_amount) AS grand_total
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name;




-- =========================================================================
-- MINI-PROJECT 4: HOSPITAL RECORDS AND APPOINTMENTS SYSTEM
-- =========================================================================

CREATE DATABASE IF NOT EXISTS hospital_db;
USE hospital_db;

-- Structure khada karna
CREATE TABLE IF NOT EXISTS doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_name VARCHAR(50) NOT NULL,
    specialization VARCHAR(50),
    experience_years INT
);

CREATE TABLE IF NOT EXISTS patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_name VARCHAR(50) NOT NULL,
    age INT,
    gender VARCHAR(10),
    city VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT,
    patient_id INT,
    appointment_date DATE,
    reason VARCHAR(100),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

-- Data daalna
INSERT INTO doctors (doctor_name, specialization, experience_years) VALUES 
('Dr. Nitin Rao', 'Cardiologist', 12),
('Dr. Neha Kapoor', 'Pediatrician', 8),
('Dr. Abdul Khan', 'Dermatologist', 15);

INSERT INTO patients (patient_name, age, gender, city) VALUES 
('Aarav Mehta', 45, 'Male', 'Delhi'),
('Kavita Shah', 29, 'Female', 'Noida'),
('Baby Ayansh', 4, 'Male', 'Delhi');

INSERT INTO appointments (doctor_id, patient_id, appointment_date, reason) VALUES 
(1, 1, '2026-10-05', 'Regular Heart Checkup'),
(2, 3, '2026-10-06', 'Routine Vaccination'),
(3, 2, '2026-10-07', 'Skin Rash Allergy');

-- Verification Queries
-- Query: Saare appointments ki list Doctors aur Patients ke real names ke sath
SELECT a.appointment_date, p.patient_name, d.doctor_name, a.reason
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id;




-- =========================================================================
-- MINI-PROJECT 5: EMPLOYEE HR & PAYROLL ANALYTICS
-- =========================================================================

CREATE DATABASE IF NOT EXISTS payroll_db;
USE payroll_db;

-- Tables structure
CREATE TABLE IF NOT EXISTS org_departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL,
    location VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL,
    hire_date DATE,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES org_departments(dept_id)
);

CREATE TABLE IF NOT EXISTS payroll_records (
    payroll_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,
    salary_month VARCHAR(20),
    basic_salary DECIMAL(10,2),
    allowances DECIMAL(10,2),
    deductions DECIMAL(10,2),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

-- Corporate data inserts
INSERT INTO org_departments (dept_name, location) VALUES 
('Human Resources', 'Tower A'),
('Software Engineering', 'Tower B'),
('Finance & Accounts', 'Tower A');

INSERT INTO employees (emp_name, hire_date, dept_id) VALUES 
('Suresh Raina', '2023-04-12', 2),
('Megha Gupta', '2024-01-20', 1),
('Hardik Pandya', '2022-11-05', 3);

INSERT INTO payroll_records (emp_id, salary_month, basic_salary, allowances, deductions) VALUES 
(1, 'October 2026', 75000.00, 12000.00, 4500.00), -- Net: Basic + Allow - Deduct
(2, 'October 2026', 45000.00, 8000.00, 2000.00),
(3, 'October 2026', 60000.00, 10000.00, 3500.00);

-- Payroll calculations query
-- Query: Har employee ki pure month ki "Net Net Salary" calculate karna mathematical logic se
SELECT e.emp_name, p.salary_month, 
       (p.basic_salary + p.allowances - p.deductions) AS net_salary_payable
FROM employees e
JOIN payroll_records p ON e.emp_id = p.emp_id;



 
