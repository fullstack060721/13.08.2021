create or replace function sp_insert_movie(_title text, _release_date timestamp, _price double precision,
                                            _country_id bigint) returns bigint
language plpgsql AS
    $$
        DECLARE
            new_id bigint;
        BEGIN
            INSERT INTO movies (title, release_date, price, country_id)
            VALUES (_title, _release_date, _price, _country_id)
            RETURNING id into new_id;

            return new_id;
        END;
    $$;

select * from sp_insert_movie('Superman returns', '2021-05-09 22:00:00', 75.1, 30);
-- delete from movies where title like 'Super%';

create or replace function sp_get_all_movies_join()
returns TABLE(id bigint, title text, release_date timestamp, price double precision, country_id bigint, country_name text)
language plpgsql AS
    $$
        BEGIN
            RETURN QUERY
            SELECT m.id, m.title, m.release_date, m.price, m.country_id, c.name from movies m
            join countries c on m.country_id = c.id;
        END;
    $$;

drop function sp_get_all_movies_join();
select * from sp_get_all_movies_join();

drop function sp_get_all_movies();
create or replace function sp_get_all_movies()
returns setof movies
language plpgsql AS
    $$
        BEGIN
            RETURN QUERY
            SELECT * from movies;
        END;
    $$;

select * from sp_get_all_movies();

create or replace function sp_get_movie_by_id(_id bigint)
returns setof movies
language plpgsql AS
    $$
        BEGIN
            RETURN QUERY
            SELECT * from movies
            WHERE id = _id;
        END;
    $$;


select * from sp_get_movie_by_id(2);

create or replace function sp_update_movies(_id bigint, _title text, _release_date timestamp, _price double precision,
                                            _country_id bigint) returns bigint
language plpgsql AS
    $$
        DECLARE
            rows_count int := 0;
        BEGIN
            WITH rows AS (
            UPDATE movies
            SET title = _title, release_date = _release_date, price = _price, country_id = _country_id
            WHERE id = _id
            RETURNING 1)
            select count(*) into rows_count from rows;
            return rows_count;
        END;
    $$;

select * from sp_update_movies(70, 'Superman returns', '2021-05-09 22:00:00', 75.1, 3);

create or replace function sp_delete_movies(_id bigint) returns bigint
language plpgsql AS
    $$
        DECLARE
            rows_count int := 0;
        BEGIN
            WITH rows AS (
            DELETE FROM movies
            WHERE id = _id
            RETURNING 1)
            select count(*) into rows_count from rows;
            return rows_count;
        END;
    $$;

select * from sp_insert_movie('Superman returns2', '2021-05-09 22:00:00', 75.1, 3);
select * from sp_delete_movies(9);

-- insert
-- get_all
-- get_all_join
-- get_by_id
-- update
-- delete
