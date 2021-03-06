#include <mio/shared_mmap.hpp>

#include <cpp11/R.hpp>
#include <cpp11/list.hpp>
#include <cpp11/strings.hpp>

#include "LocaleInfo.h"
#include "columns.h"
#include "connection.h"
#include "index.h"
#include "index_collection.h"
#include "vroom_rle.h"
#include <algorithm>
#include <numeric>

#include "unicode_fopen.h"

[[cpp11::register]] SEXP vroom_(
    cpp11::list inputs,
    SEXP delim,
    const char quote,
    bool trim_ws,
    bool escape_double,
    bool escape_backslash,
    const char comment,
    size_t skip,
    ptrdiff_t n_max,
    bool progress,
    cpp11::sexp col_names,
    cpp11::sexp col_types,
    cpp11::sexp col_select,
    SEXP id,
    cpp11::strings na,
    cpp11::list locale,
    ptrdiff_t guess_max,
    size_t num_threads,
    size_t altrep) {

  bool has_header =
      TYPEOF(col_names) == LGLSXP && cpp11::logicals(col_names)[0];

  std::vector<std::string> filenames;

  bool add_filename = !Rf_isNull(id);

  // We need to retrieve filenames now before the connection objects are read,
  // as they are invalid afterwards.
  if (add_filename) {
    filenames = get_filenames(inputs);
  }

  auto idx = std::make_shared<vroom::index_collection>(
      inputs,
      Rf_isNull(delim) ? nullptr : cpp11::as_cpp<const char*>(delim),
      quote,
      trim_ws,
      escape_double,
      escape_backslash,
      has_header,
      skip,
      n_max,
      comment,
      num_threads,
      progress);

  return create_columns(
      idx,
      col_names,
      col_types,
      col_select,
      id,
      filenames,
      na,
      locale,
      altrep,
      guess_max,
      num_threads);
}

[[cpp11::register]] bool has_trailing_newline(cpp11::strings filename) {
  std::FILE* f = unicode_fopen(CHAR(filename[0]), "rb");

  if (!f) {
    return true;
  }

  std::setvbuf(f, NULL, _IONBF, 0);

  fseek(f, -1, SEEK_END);
  char c = fgetc(f);

  fclose(f);

  return c == '\n';
}

[[cpp11::register]] SEXP vroom_rle(cpp11::integers input) {
#ifdef HAS_ALTREP
  return vroom_rle::Make(input);
#else
  R_xlen_t total_size = std::accumulate(input.begin(), input.end(), 0);
  cpp11::writable::strings out(total_size);
  cpp11::strings nms = input.names();
  R_xlen_t idx = 0;
  for (R_xlen_t i = 0; i < Rf_xlength(input); ++i) {
    for (R_xlen_t j = 0; j < input[i]; ++j) {
      SET_STRING_ELT(out, idx++, nms[i]);
    }
  }
  return out;
#endif
}
