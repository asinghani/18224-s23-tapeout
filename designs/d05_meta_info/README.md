# Informational ROM

Outputs informational text about each project (project title and creator) as well as some information about the course itself.

The top 6 bits of `io_in` are the project ID, and the lower 6 bits are the character index. The low 8 bits of `io_out` are the ASCII character (there is a one-cycle delay between the bit input and the character output). Each individual string is C-style null-terminated, and all characters after the null terminator are undefined (due to the use of Q-M optimization). Project IDs not associated with a project will have the empty string (just a null terminator) as their info-string. IDs 60-63 are used for information regarding the tapeout.

To read the string for a given project, feed the project ID as the upper 6 bits of `io_in`, and all zeros for the lower 6 bits. This will provide the first character on the next clock cycle. Increment the lower 6 bits, reading one character at a time until the null character (at which point the string is terminated).
