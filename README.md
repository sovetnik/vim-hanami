# vim-hanami

Hanami support plugin for vim that gives you faster navigation between semantically associated files, like Entity -> Repository or Spec -> Entity.

## Installation

Add this to your `.vimrc` or `nvim/init.vim`:
```
Plug 'sovetnik/vim-hanami'
```

## Usage

The plugin registers `<Leader>s`(SpecToggle) and `<Leader>x`(RepoToggle) in normal mode for toggle files.

Some public commands:
`:HanamiRepoToggle` toggles between entity and repo.
`:HanamiSpecToggle` toggles between lib and spec.
`:HanamiProject` returnes project name from `.hanamirc`

## Toggles

Assume we have generated a hanami entity.

Suppose you run 'hanami g model fnord' and get files:
- `lib/bookshelf/entities/fnord.rb`
- `lib/bookshelf/repositories/fnord_repository.rb`
- `spec/bookshelf/entities/fnord_spec.rb`
- `spec/bookshelf/repositories/fnord_repository_spec.rb`

Toggle command simply splits window with toggled file.
<img src="./images/quad.jpg" />

### RepoToggle
This command mapped to `<Leader>x` adds or removes repo related parts from path of current buffer file.
<img src="./images/er.jpg" />
<img src="./images/re.jpg" />

### SpecToggle
This command mapped to `<Leader>s` adds or removes spec related parts from path of current buffer file.
<img src="./images/er.jpg" />
<img src="./images/re.jpg" />

## Settins

In your `~/.vimrc` or `~/.config/nvim/init.vim` add this statement to change open strategy:
```vim
let g:hanami_open_strategy = 'vsplit'
```
Default strategy is `split`.

## Next features(planned)

- navigation in app folder
- something else

## License

The Vim Hanami plugin is open-sourced software licensed under the [MIT license](http://opensource.org/licenses/MIT).

