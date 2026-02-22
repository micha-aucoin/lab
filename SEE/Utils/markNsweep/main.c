#include <stdio.h>
#include <stdio.h>
/*#include <stdlib.h>*/

#include "sneknew.h"
#include "snekobject.h"
#include "vm.h"

int main() {
    vm_t *vm = vm_new();
    frame_t *f1 = vm_new_frame(vm);
    frame_t *f2 = vm_new_frame(vm);
    frame_t *f3 = vm_new_frame(vm);

    snek_object_t *s1 = new_snek_string(vm, "This string is going into frame 1");
    frame_reference_object(f1, s1);

    snek_object_t *s2 = new_snek_string(vm, "This string is going into frame 2");
    frame_reference_object(f2, s2);

    snek_object_t *s3 = new_snek_string(vm, "This string is going into frame 3");
    frame_reference_object(f3, s3);

    snek_object_t *i1 = new_snek_integer(vm, 69);
    snek_object_t *i2 = new_snek_integer(vm, 420);
    snek_object_t *i3 = new_snek_integer(vm, 1337);
    snek_object_t *v = new_snek_vector3(
        vm,
        i1,
        i2,
        i3
    );
    frame_reference_object(f2, v);
    frame_reference_object(f3, v);

    printf("should be 7 objects: %lu", vm->objects->count);

    // only free the top frame (f3)
    frame_free(vm_frame_pop(vm));
    vm_collect_garbage(vm);

    printf("should be _ objects: %lu", vm->objects->count);

    // VM pass should free the string, but not the vector
    // because its final frame hasn't been freed
    frame_free(vm_frame_pop(vm));
    frame_free(vm_frame_pop(vm));
    vm_collect_garbage(vm);


    vm_free(vm);
    return 0;
}
