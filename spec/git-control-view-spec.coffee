git = require '../lib/git'
GitControlView = require '../lib/git-control-view'

describe "GitControlView", ->
  updateSpy = null
  stashSaveSpy = null
  stashPopSpy = null
  gitControlView = null

  beforeEach ->
    gitControlView = new GitControlView()
    updateSpy = spyOn(gitControlView, 'update')
    fakePromise = then : (f) -> f()
    stashSaveSpy = spyOn(git, 'stashSave').andReturn(fakePromise)
    stashPopSpy = spyOn(git, 'stashPop').andReturn(fakePromise)

  it "calls git stashSave on Stash Save", ->
    gitControlView.stashSaveMenuClick()
    expect(stashSaveSpy).toHaveBeenCalled()
    expect(updateSpy).toHaveBeenCalled()

  it "calls git stashPop on Stash Pop", ->
    gitControlView.stashPopMenuClick()
    expect(stashPopSpy).toHaveBeenCalled()
    expect(updateSpy).toHaveBeenCalled()
