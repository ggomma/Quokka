import { ethers } from 'hardhat';
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
const { getSelectors } = require('../scripts/libraries/diamond.js');

describe('Deploy test', () => {
  let accounts: SignerWithAddress[];

  beforeEach(async () => {
    accounts = await ethers.getSigners();
  });

  it('test', async function () {
    const DiamondCutFacet = await ethers.getContractFactory('DiamondCutFacet');
    const diamondCutFacet = await DiamondCutFacet.deploy();

    const DiamondLoupe = await ethers.getContractFactory('DiamondLoupeFacet');
    const diamondLoupe = await DiamondLoupe.deploy();

    const Diamond = await ethers.getContractFactory('Diamond');
    const diamond = await Diamond.deploy(
      accounts[0].address,
      diamondCutFacet.address
    );

    const DiamondInit = await ethers.getContractFactory('InitDiamond');
    const diamondInit = await DiamondInit.deploy();

    const FacetNames = [
      'DiamondLoupeFacet',
      'OwnershipFacet',
      'MainTokenFacet',
    ];
    const cut = [];
    for (const FacetName of FacetNames) {
      const Facet = await ethers.getContractFactory(FacetName);
      const facet = await Facet.deploy();

      cut.push({
        facetAddress: facet.address,
        action: 0, // Add
        functionSelectors: getSelectors(facet),
      });
    }

    const functionCall = diamondInit.interface.encodeFunctionData('init');
    const diamondCutFromDiamond = await ethers.getContractAt(
      'IDiamondCut',
      diamond.address
    );
    await diamondCutFromDiamond.diamondCut(
      cut,
      diamondInit.address,
      functionCall
    );

    const erc20 = await ethers.getContractAt('IMainToken', diamond.address);
    const name = await erc20.name();
    console.log(name);
  });
});
