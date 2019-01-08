import $ from 'zepto-modules/_min'
import _ethers from 'ethers/dist/ethers'
import web3 from './web3'
import aes from 'aes-js'

# astley needs to be executed before shop.js sequentially
import './astley'
import './coin'

window?.$ = $
window?.ethers = _ethers.ethers
window?.aes = aes
window?.web3 = web3
