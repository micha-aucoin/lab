typedef struct Employee employee_t;
typedef struct Department department_t;

typedef struct Employee {
    int id;
    char *name;
    department_t *department;
} employee_t;

typedef struct Department {
    char *name;
    employee_t *manager;
} department_t;

employee_t create_employee(int id, char *name);
department_t create_department(char *name);

void assign_employee(employee_t *emp, department_t *dept);
void assign_manager(department_t *dept, employee_t *manager);
