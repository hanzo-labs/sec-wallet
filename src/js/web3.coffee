import { ETH_ENDPOINT } from './constants'

if typeof web3 != 'undefined'
  web3 = new Web3(Web3.givenProvider || ETH_ENDPOINT)
else
  # Set the provider you want from Web3.providers
  web3 = new Web3 ETH_ENDPOINT

export default web3
