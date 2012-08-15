# mydumpall

Dump mysql dbs to appropriately named .sql files

mysql args: `[-u user] [-p password] [-h host] [-S socket] [-P port]`

All "long" args (starting with `--`) are passed to mysqldump only
Note that such args must not have separate parameters. So the
correct syntax would be `--user=joe` rather than `--user joe`

If `-R` is *not* passed, then all non-option command-line arguments 
are database names to dump.

If `-R` *is* passed, then all non-option command-line arguments are
regular expressions matched by bash against the list of database
names.  Expressions starting with ":" are negated,
meaning that databases matching will be filtered out. Filters are
processed in the order they appear on the command line. 

Passing no database names or patterns, or no non-negated database
names or patterns implies that all database not explicitly excluded
should be *included*.

E.g.:  

    mydumpall -S /tmp/mysql.socket :^mysql
	# dumps all databases that don't start with "mysql" using provided socket

    mydumpall ^my :^mysql$
	# dumps databases starting with "my" except for "mysql"

	mydumpall --complete-insert --no-create-info
	# dump data only, and use "complete" inserts that don't rely on
	# table order for correctness. Includes all tables.

	mydumpall --single-transaction
	# It's usually a good idea to dump as a single-transaction, it generally
	# speeds things up.

# myload

    ./myload <SQL files...>

Restores MySQL dump files as a one-db-per-file basis.

Uses the filename as the database name, stripping off `.sql` if present

If filename ends in `.gz` then file is assumed to be gzip compressed, and 
`.gz` is not assumed to be part the filename

For example all of the following filenames map to the database name mydb

* mydb
* mydb.gz
* mydb.sql
* mysql.sql.gz
* /foo/mydb.sql

