# vim-hanami

Hanami support plugin for vim that gives you faster navigation between semantically 
associated files, like Action <-> View, Entity -> Repository or Spec -> Entity.

Spec <-> Entity association works if code lives in `lib` and specs in 'spec' directoties. 

## Installation

Add this to your `.vimrc` or `nvim/init.vim`:
```
Plug 'sovetnik/vim-hanami'
```

## Usage

The plugin registers `<Leader>s`(SpecToggle) and `<Leader>x`(RepoToggle) in normal mode for toggle files.

Some public commands:
`:HanamiAlterToggle` toggles between entity and repo.
`:HanamiSpecToggle` toggles between lib and spec.
`:HanamiProject` returnes project name from `.hanamirc`
`:HanamiTemplate` returnes template engine from `.hanamirc`

## Toggles

Assume we have generated a hanami entity or action.

Suppose you run `hanami g model fnord` and get files:
- `lib/bookshelf/entities/fnord.rb`
- `lib/bookshelf/repositories/fnord_repository.rb`
- `spec/bookshelf/entities/fnord_spec.rb`
- `spec/bookshelf/repositories/fnord_repository_spec.rb`
<img src="./images/quad_lib.jpg" />

Or we run `hanami generate action web foobar#show` and get:
- `spec/web/controllers/foobar/show_spec.rb`
- `apps/web/controllers/foobar/show.rb`
- `apps/web/views/foobar/show.rb`
- `apps/web/templates/foobar/show.html.erb`
- `spec/web/views/foobar/show_spec.rb`
<img src="./images/quad_app.jpg" />

Toggle command simply splits window with alter or spec file.

### AlterToggle
This command mapped to `<Leader>x` 
From buffer with Action, View or its specs toggles between them, Action <-> View.  
<img src="./images/av.jpg" />
<img src="./images/va.jpg" />

From buffer with Entity, Repository or its specs toggles between them, Entity <-> Repo.
<img src="./images/er.jpg" />
<img src="./images/re.jpg" />

### SpecToggle
This command mapped to `<Leader>s` 
From Action, Entity, Repository and View toggles between them and their specs. 
<img src="./images/as.jpg" />
<img src="./images/ls.jpg" />
<img src="./images/sa.jpg" />
<img src="./images/sl.jpg" />

## Settings

In your `~/.vimrc` or `~/.config/nvim/init.vim` add this statement to change open strategy:
```vim
let g:hanami_open_strategy = 'vsplit'
```
Default strategy is `split`.

You can disable included mappings:
```vim
let g:hanami_map_keys = 0
```
By default mappings enabled.

## Next features(planned)

- navigation in app folder
- something else

## License

The Vim Hanami plugin is open-sourced software licensed under the [MIT license](http://opensource.org/licenses/MIT).

