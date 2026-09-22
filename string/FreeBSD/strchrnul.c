#include <sys/cdefs.h>
#include <string.h>

char *
strchrnul(const char *p, int ch)
{
	char c;

	c = (char)ch;
	for (;; ++p) {
		if (*p == c || *p == '\0')
			return ((char *)p);
	}
	/* NOTREACHED */
}
