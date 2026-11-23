#include <stdlib.h>
#include <Block_private.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wimplicit-function-declaration"
#pragma clang diagnostic ignored "-Wstrict-prototypes"
#pragma clang diagnostic ignored "-Wint-conversion"

typedef int cmp_t(const void *, const void *);

void
qsort_b(void *base, size_t nel, size_t width, cmp_t ^cmp_b)
{
	struct Block_layout *layout = (struct Block_layout *)cmp_b;
#if __has_feature(ptrauth_calls)
	// invoke is signed with the block-function key and its storage address; qsort_r calls
	// the comparator as a plain C function pointer
	void *cmp_f = ptrauth_auth_and_resign((void *)layout->invoke,
			ptrauth_key_block_function, &layout->invoke, ptrauth_key_function_pointer, 0);
#else
	void *cmp_f = layout->invoke;
#endif
	qsort_r(base, nel, width, cmp_b, (void*)cmp_f);
}
#pragma clang diagnostic pop
