import store from 'akasha'
import { getBalance } from './ustContract'

export updateBalance = (data, cb)->
  setInterval ->
    if addr = store.get 'ethAddress'
      getBalance addr
        .then (results) =>
          store.set 'ethBalance', results
          data.set 'ethBalance', results
          cb(results) if cb?
        .catch (err) ->
          console.log 'Error', err
  , 1000
