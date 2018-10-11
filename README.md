This is the gh-pages site for the Conga-Comic - life on the chain one block at a time.

Any opinion, view point, statement of fact is of the individual author, and does not represent IBM, Hyperledger or the Linux Foundation.

## Adding a new comic

- Fork the repo
- Add the new image to the `assets\imgs` directory.
  - Naming convetion is `blockheight-xx.png`
- In the `_posts` directory duplicate the `template.md` file following the convention `YYYY-MM-DD-height-xx.md`
- Adjust the contents of the front matter, to refer to the image uploaded, just the name not the path
- Update the title, and description

## Adding text to a comic
The idea is to explain the idea that is being discussed.

- Same procedure as above, fork the repo.
- In the `_posts` directory add markdown formatted text BELOW the ----

## Submit the PR
And 'poke' the owners to merge it.


## Building locally

Issue the command

```
bundle exec jekyll serve
```

