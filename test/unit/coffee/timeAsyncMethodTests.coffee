require('coffee-script')
chai = require('chai')
should = chai.should()
expect = chai.expect
path = require('path')
modulePath = path.join __dirname, '../../../timeAsyncMethod.coffee'
SandboxedModule = require('sandboxed-module')
sinon = require("sinon")


describe 'timeAsyncMethod', ->

	beforeEach ->
		@Timer = {done: sinon.stub()}
		@TimerConstructor = sinon.stub().returns(@Timer)
		@metrics = {
			Timer: @TimerConstructor
		}
		@timeAsyncMethod = SandboxedModule.require modulePath, requires:
			'./metrics': @metrics

		@testObject = {
			nextNumber: (n, callback=(err, result)->) ->
				setTimeout(
					() ->
						callback(null, n+1)
					, 100
				)
		}

	it 'should have the testObject behave correctly before wrapping', (done) ->
		@testObject.nextNumber 2, (err, result) ->
			expect(err).to.not.exist
			expect(result).to.equal 3
			done()

	it 'should wrap method without error', (done) ->
		@timeAsyncMethod @testObject, 'nextNumber', 'test.nextNumber'
		done()

	it 'should transparently wrap method invocation in timer', (done) ->
		@timeAsyncMethod @testObject, 'nextNumber', 'test.nextNumber'
		@testObject.nextNumber 2, (err, result) =>
			expect(err).to.not.exist
			expect(result).to.equal 3
			expect(@TimerConstructor.callCount).to.equal 1
			expect(@Timer.done.callCount).to.equal 1
			done()

