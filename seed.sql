CREATE TABLE public.films (
    id SERIAL PRIMARY KEY,
    title text NOT NULL,
    description text,
    release_year INTEGER NOT NULL
);

INSERT INTO public.films (
    title,
    description,
    release_year
) SELECT 
    'A Fake Movie ' || s,
	'A fake movie used to for load testing. Not very interesting. Like, at all.',
    2020
FROM generate_series(1, 100000) as s;