#include <stdlib.h>
#include <stdio.h>
#include "jpeglib.h"

void jinit_c_master_control (struct jpeg_compress_struct *cinfo);

void *alloc_small(j_common_ptr cinfo, int pool_id, size_t sizeofobject) {
    return malloc(sizeofobject);
}

int main(void) {
    struct jpeg_compress_struct dstinfo;
    struct jpeg_memory_mgr mem;
    mem.alloc_small = alloc_small;
    dstinfo.mem = &mem;

    jinit_c_master_control(&dstinfo);
    return 0;
}
