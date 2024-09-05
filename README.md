# Linux Administration Fundamentals

This is a reference for how to use common Linux command line tools for system administration.

1. `grep` = Global / Regular Expression Search / and Print. [Manual](https://www.gnu.org/software/grep/manual/).
1. `sed` = Stream Editor. [Manual](https://www.gnu.org/software/sed/manual/).
1. `awk` = Tool named for the initials of its designers. [Manual](https://www.gnu.org/software/gawk/manual/gawk.html).

## grep command

Files are searched using a regular expression. We can use metacharacters in our regular expression, such as `^` for the start of a line and `$` for the end of a line. We can also use options, like `-c`, to just count the lines that match.

Here's an example of counting the number of times `/tcp` appears in `/etc/services`:

```bash
grep -c '/tcp' /etc/services
```

Below we're counting the number of lines that end with `/tcp` in `/etc/services`:

```bash
grep -c '/tcp$' /etc/services
```

Quotes are only required if we're using metacharacters. Thus, the following two commands are identical:

```bash
grep -c /tcp /etc/services
grep -c '/tcp' /etc/services
```

It's nevertheless a good idea to use quotes. 

Double-quotes are required if we want to pass variables.

What if we want more complex regular expressions, like ones with parenthesis? For that we need to use the `-E` option. In this example, we want to output all lines from `etc/services` that contain either "udp" or "tcp".

```bash
grep -E '/(udp|tcp)' /etc/services
```

The `-v` option reverses the search. Now we'll show all lines that do not contain either "udp" or "tcp":

```bash
grep -vE '/(udp|tcp)' /etc/services
```

We can use these features to our benefit. Think about how many config files have lots of comments in them. We can print just the so-called "effective" lines in the config files (the lines that don't start with a `#`) using `grep` like such:

```bash
grep -vE '^(#|$)' /etc/ssh/ssh_config
```

The regular expression '^\(\#\|\$\)' will match all lines that start with "\#" and "\$". The `-v` option reverses that match and ensures only lines that don't start with "\#" or "\$" are displayed instead.

### Grep File Globbing

Up to now, the `grep` examples have been matching in a single file. But we can use file globbing to list matches across many files.

```bash
grep 'pam_motd' /etc/pam.d/*
```

Output:

```
/etc/pam.d/login:session    optional   pam_motd.so motd=/run/motd.dynamic
/etc/pam.d/login:session    optional   pam_motd.so noupdate
```

Notice that `grep` listed the file names. The `*` at the end of the path tells `grep` to match within any file inside of `pam.d`.

This is great, but what if we just want to see the file names where matches were found and not output all the matched lines? Easy; we use the `-l` option:

```bash
grep -l 'pam_motd' /etc/pam.d/*
```

Output: 

```
/etc/pam.d/login
```



## tr command

`tr` is short for translate. Let's say we have a space-delimited file that we want to turn into a comma-separated values file. Here's how we might create such a space-delimited file:

```bash
echo "David 23 Atlanta" >> people.txt
echo "Maria 37 Chicago" >> people.txt
```

Here's one way we could convert that to a CSV file:

```bash
tr ' ' ',' < people.txt > people.csv
cat people.csv
```

The above command takes `people.txt`, replaces the spaces with commas, and outputs the translated content to `people.csv`.

Let's loop over the contents of this CSV file. Note that the Internal Field Separator (IFS) for the shell session is a space; but since we have a CSV file now, we want to separate fields with a comma. Here's how we might do that:

```bash
OLDIFS="$IFS"
IFS=','
while read name age city; do
    echo $name
    echo $age
    echo $city
done < people.csv
IFS="$OLDIFS"
```

These lines in the script above ensure that we reset the IFS back to its previous value:

```bash
OLDIFS="$IFS"
IFS=','
...
IFS="$OLDIFS"
```