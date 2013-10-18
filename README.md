HH
================

This is the source for
[site.example.com](http://site.example.com/).
and currently under development.

Bug reports and whatnot can be viewed/added on the github issues page.


Getting Started
---------------

To run the site on you local machine do the following steps (it
assumes that you use rvm).

1.  Install required gems with bundler:

    ```bash
    bundle install --witnout production
    ```
2.  Install nessesery programs

    ```bash
    apt-get install mysql
    ```

3.  Create `config/database.yml`.  You can use `database_example.yml`
    as an example.

4.  Setup the database:

    ```bash
    rake db:setup
    rake db:populate
    rake db:test:prepare
    ```

