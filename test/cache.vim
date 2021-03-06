let s:suite  = themis#suite('iced.cache')
let s:assert = themis#helper('assert')

function! s:suite.get_and_set_test() abort
  call s:assert.equals(iced#cache#get('foo'), '')
  call s:assert.equals(iced#cache#get('foo', 'baz'), 'baz')

  call iced#cache#set('foo', 'bar')
  call s:assert.equals(iced#cache#get('foo'), 'bar')
endfunction

function! s:suite.delete_test() abort
  call iced#cache#set('foo', 'bar')
  call s:assert.equals(iced#cache#get('foo'), 'bar')
  call iced#cache#delete('foo')
  call s:assert.equals(iced#cache#get('foo'), '')
endfunction

function! s:suite.merge_test() abort
  call iced#cache#set('foo', 'bar')
  call s:assert.equals(iced#cache#get('foo'), 'bar')
  call s:assert.equals(iced#cache#get('hello'), '')

  call iced#cache#merge({'foo': 'baz', 'hello': 'world'})
  call s:assert.equals(iced#cache#get('foo'), 'baz')
  call s:assert.equals(iced#cache#get('hello'), 'world')
endfunction

function! s:suite.clear_test() abort
  call iced#cache#merge({'foo': 'bar', 'bar': 'baz'})
  call s:assert.equals(iced#cache#get('foo'), 'bar')
  call s:assert.equals(iced#cache#get('bar'), 'baz')

  call iced#cache#clear()
  call s:assert.equals(iced#cache#get('foo'), '')
  call s:assert.equals(iced#cache#get('bar'), '')
endfunction

function! s:suite.has_key_test() abort
  call iced#cache#clear()
  call s:assert.false(iced#cache#has_key('foo'))

  call iced#cache#set('foo', 'bar')
  call s:assert.true(iced#cache#has_key('foo'))

  call iced#cache#delete('foo')
  call s:assert.false(iced#cache#has_key('foo'))
endfunction

function! s:set(k, v, r) abort
  call iced#cache#set(a:k, a:v)
  return a:r
endfunction

function! s:suite.do_once_test() abort
  call iced#cache#clear()
  call s:set('i', 1, v:true)

  call iced#cache#do_once('foo', {-> s:set('i', iced#cache#get('i') + 1, v:true)})
  call s:assert.equals(iced#cache#get('i'), 2)
  call iced#cache#do_once('foo', {-> s:set('i', iced#cache#get('i') + 1, v:true)})
  call s:assert.equals(iced#cache#get('i'), 2)

  call iced#cache#do_once('bar', {-> s:set('i', iced#cache#get('i') + 1, v:false)})
  call s:assert.equals(iced#cache#get('i'), 3)
  call iced#cache#do_once('bar', {-> s:set('i', iced#cache#get('i') + 1, v:false)})
  call s:assert.equals(iced#cache#get('i'), 4)
endfunction
