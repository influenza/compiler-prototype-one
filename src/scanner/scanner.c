#include "scanner.h"
#include "scl_parser.h"

extern int scan_file(FILE *);

void perform_scan(FILE *file)
{
  scan_file(file);
}
