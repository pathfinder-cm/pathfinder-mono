# Global configuration
# -----------------------------------------------------------------------------

CODE_FORMAT         = /\A(?![._\-\/])[\p{Alpha}\d._\-\/]+(?<![._\-\/])\z/
IDENT_NAME_FORMAT   = /\A(?![_])[A-Z\d_]+(?<![_])\z/
NUMBER_FORMAT       = /\A(?![.:_\- \/])[a-zA-Z\d.:_\- \/]+(?<![.:_\- \/])\z/
USERNAME_FORMAT     = /\A(?![._])[a-zA-Z0-9._]{3,24}(?<![._])\z/

# Pagination
DEFAULT_SEARCH_PER_PAGE = 20

# App specific
# -----------------------------------------------------------------------------

# Misc configuration
# -----------------------------------------------------------------------------

DAYS_OF_WEEK = [
  {id: 1, name: "Monday"},
  {id: 2, name: "Tuesday"},
  {id: 3, name: "Wednesday"},
  {id: 4, name: "Thursday"},
  {id: 5, name: "Friday"},
  {id: 6, name: "Saturday"},
  {id: 7, name: "Sunday"}
]

# Time in seconds
MINUTE_IN_SECONDS = 60
HOUR_IN_SECONDS = MINUTE_IN_SECONDS * 60
DAY_IN_SECONDS = HOUR_IN_SECONDS * 24
WEEK_IN_SECONDS = DAY_IN_SECONDS * 7

# DateTime constants
MIN_DATE_TIME = DateTime.new(1970,1,1)
MAX_DATE_TIME = DateTime.new(2106,2,7,6,28,15)
