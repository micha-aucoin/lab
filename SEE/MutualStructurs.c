#include <stdio.h>

#include "MutualStructurs.h"

employee_t create_employee(int id, char *name) {
    employee_t emp = {
        .id = id,
        .name = name
    };
    return emp;
}

department_t create_department(char *name) {
    department_t dept = {
        .name = name
    };
    return dept;
}

void assign_employee(employee_t *emp, department_t *dept) {
    emp->department = dept;
}
void assign_manager(department_t *dept, employee_t *manager) {
    dept->manager = manager;
}

int main() {
    employee_t emp1 = create_employee(1, "emp1");
    employee_t emp2 = create_employee(2, "emp2");
    employee_t emp3 = create_employee(3, "emp3");

    department_t dept1 = create_department("dept1");
    department_t dept2 = create_department("dept2");

    assign_employee(&emp1, &dept1);
    assign_employee(&emp2, &dept1);
    assign_employee(&emp3, &dept2);

    assign_manager(&dept1, &emp1);
    assign_manager(&dept2, &emp3);

    printf("emp1.department->name = %s\n", emp1.department->name);
    printf("emp2.department->name = %s\n", emp2.department->name);
    printf("emp3.department->name = %s\n", emp3.department->name);
    printf("dept1.manager->name   = %s\n", dept1.manager->name);
    printf("dept2.manager->name   = %s\n", dept2.manager->name);
}
