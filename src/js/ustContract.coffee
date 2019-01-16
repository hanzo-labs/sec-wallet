import tokenContract from '../USDToken'
import { ETH_CONTRACT_ADDRESS } from './constants'
import web3 from './web3.coffee'

export default contract = new web3.eth.Contract(tokenContract.abi, ETH_CONTRACT_ADDRESS)

export getBalance = (addr) ->
  return contract.methods.balanceOf(addr).call()
