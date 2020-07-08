<?php

/**
 * $Id: $
 */

namespace Shopware\CustomModels\MoptPayoneRatepay;

use Doctrine\ORM\NonUniqueResultException;
use Shopware\Components\Model\ModelRepository;

/**
 * Payone Paypal Repository
 */
class Repository extends ModelRepository
{
    
    public function getRatepayConfigByShopId($id, $asArray = true)
    {
        $builder = $this->getEntityManager()->createQueryBuilder();
        $builder->select('c')
            ->from('Shopware\CustomModels\MoptPayoneRatepay\MoptPayoneRatepay', 'c')
            ->where('c.shopid = ?1')
            ->setParameter(1, $id);

        $hydrationMode = $asArray ? \Doctrine\ORM\AbstractQuery::HYDRATE_ARRAY : \Doctrine\ORM\AbstractQuery::HYDRATE_OBJECT;
        $query = $builder->getQuery();
        try {
            $result = $query->getOneOrNullResult($hydrationMode);
        } catch (NonUniqueResultException $e) {
            $result = $query->getArrayResult()[0];
        }

        return $result;
    }    
    
}
