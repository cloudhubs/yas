# Flow Matrix

| Flow Name | Path | Operation | Role | Data State |
|-----------|------|-----------|------|------------|
| cart_add_item_customer_success | storefront-bff → cart → product | POST /cart/storefront/cart/items | CUSTOMER | success |
| cart_add_item_unauthenticated | storefront-bff → cart | POST /cart/storefront/cart/items | NONE | unauthenticated |
| cart_get_items_customer_success | storefront-bff → cart | GET /cart/storefront/cart/items | CUSTOMER | success |
| cart_update_item_customer_success | storefront-bff → cart | PUT /cart/storefront/cart/items/{productId} | CUSTOMER | success |
| cart_update_item_not_found | storefront-bff → cart | PUT /cart/storefront/cart/items/{productId} | CUSTOMER | not_found |
| cart_delete_item_customer_success | storefront-bff → cart | DELETE /cart/storefront/cart/items/{productId} | CUSTOMER | success |
| cart_delete_item_not_found | storefront-bff → cart | DELETE /cart/storefront/cart/items/{productId} | CUSTOMER | not_found |
| cart_remove_items_customer_success | storefront-bff → cart | POST /cart/storefront/cart/items/remove | CUSTOMER | success |
| customer_get_profile_customer_success | storefront-bff → customer | GET /customer/storefront/customer/profile | CUSTOMER | success |
| customer_get_profile_unauthenticated | storefront-bff → customer | GET /customer/storefront/customer/profile | NONE | unauthenticated |
| customer_create_address_customer_success | storefront-bff → customer → location | POST /customer/storefront/user-address | CUSTOMER | success |
| customer_get_addresses_customer_success | storefront-bff → customer | GET /customer/storefront/user-address | CUSTOMER | success |
| customer_get_default_address_customer_success | storefront-bff → customer | GET /customer/storefront/user-address/default-address | CUSTOMER | success |
| customer_delete_address_customer_success | storefront-bff → customer | DELETE /customer/storefront/user-address/{id} | CUSTOMER | success |
| customer_delete_address_not_found | storefront-bff → customer | DELETE /customer/storefront/user-address/{id} | CUSTOMER | not_found |
| customer_set_default_address_customer_success | storefront-bff → customer | PUT /customer/storefront/user-address/{id} | CUSTOMER | success |
| customer_list_admin_success | storefront-bff → customer | GET /customer/backoffice/customers | ADMIN | success |
| customer_list_admin_unauthorized | storefront-bff → customer | GET /customer/backoffice/customers | CUSTOMER | unauthorized |
| order_create_checkout_customer_success | storefront-bff → order → cart → product → tax → promotion | POST /order/storefront/checkouts | CUSTOMER | success |
| order_create_checkout_unauthenticated | storefront-bff → order | POST /order/storefront/checkouts | NONE | unauthenticated |
| order_get_checkout_customer_success | storefront-bff → order | GET /order/storefront/checkouts/{id} | CUSTOMER | success |
| order_get_checkout_not_found | storefront-bff → order | GET /order/storefront/checkouts/{id} | CUSTOMER | not_found |
| order_update_checkout_payment_method_success | storefront-bff → order | PUT /order/storefront/checkouts/{id}/payment-method | CUSTOMER | success |
| order_create_order_customer_success | storefront-bff → order → cart → product → tax | POST /order/storefront/orders | CUSTOMER | success |
| order_get_my_orders_customer_success | storefront-bff → order | GET /order/storefront/orders/my-orders | CUSTOMER | success |
| order_get_order_by_checkout_success | storefront-bff → order | GET /order/storefront/orders/checkout/{id} | CUSTOMER | success |
| order_check_completed_success | storefront-bff → order | GET /order/storefront/orders/completed | CUSTOMER | success |
| order_list_admin_success | storefront-bff → order | GET /order/backoffice/orders | ADMIN | success |
| order_list_admin_unauthorized | storefront-bff → order | GET /order/backoffice/orders | CUSTOMER | unauthorized |
| rating_create_rating_customer_success | storefront-bff → rating → product → order | POST /rating/storefront/ratings | CUSTOMER | success |
| rating_create_rating_unauthenticated | storefront-bff → rating | POST /rating/storefront/ratings | NONE | unauthenticated |
| rating_get_product_ratings_public_success | storefront-bff → rating | GET /rating/storefront/ratings/products/{productId} | PUBLIC | success |
| rating_get_product_ratings_not_found | storefront-bff → rating | GET /rating/storefront/ratings/products/{productId} | PUBLIC | not_found |
| rating_get_avg_star_public_success | storefront-bff → rating | GET /rating/storefront/ratings/product/{productId}/average-star | PUBLIC | success |
| rating_list_admin_success | storefront-bff → rating | GET /rating/backoffice/ratings | ADMIN | success |
| rating_list_admin_unauthorized | storefront-bff → rating | GET /rating/backoffice/ratings | CUSTOMER | unauthorized |
| rating_delete_admin_success | storefront-bff → rating | DELETE /rating/backoffice/ratings/{id} | ADMIN | success |
| product_get_by_slug_public_success | storefront-bff → product | GET /product/storefront/product/{slug} | PUBLIC | success |
| product_get_by_slug_not_found | storefront-bff → product | GET /product/storefront/product/{slug} | PUBLIC | not_found |
| product_get_featured_public_success | storefront-bff → product | GET /product/storefront/products/featured | PUBLIC | success |
| product_browse_public_success | storefront-bff → product | GET /product/storefront/products | PUBLIC | success |
| product_browse_by_brand_public_success | storefront-bff → product | GET /product/storefront/brand/{brandSlug}/products | PUBLIC | success |
| product_browse_by_category_public_success | storefront-bff → product | GET /product/storefront/category/{categorySlug}/products | PUBLIC | success |
| product_create_admin_success | storefront-bff → product | POST /product/backoffice/products | ADMIN | success |
| product_create_admin_unauthorized | storefront-bff → product | POST /product/backoffice/products | CUSTOMER | unauthorized |
| product_update_admin_success | storefront-bff → product | PUT /product/backoffice/products/{id} | ADMIN | success |
| product_update_admin_not_found | storefront-bff → product | PUT /product/backoffice/products/{id} | ADMIN | not_found |
| product_delete_admin_success | storefront-bff → product | DELETE /product/backoffice/products/{id} | ADMIN | success |
| promotion_verify_success | storefront-bff → promotion → product | POST /promotion/storefront/promotions/verify | PUBLIC | success |
| promotion_create_admin_success | storefront-bff → promotion | POST /promotion/backoffice/promotions | ADMIN | success |
| promotion_list_admin_success | storefront-bff → promotion | GET /promotion/backoffice/promotions | ADMIN | success |
| inventory_list_stock_admin_success | storefront-bff → inventory | GET /inventory/backoffice/stocks | ADMIN | success |
| inventory_create_warehouse_admin_success | storefront-bff → inventory | POST /inventory/backoffice/warehouses | ADMIN | success |
| tax_list_admin_success | storefront-bff → tax | GET /tax/backoffice/tax-classes | ADMIN | success |
| tax_create_admin_success | storefront-bff → tax | POST /tax/backoffice/tax-classes | ADMIN | success |
| payment_init_success | storefront-bff → payment → order | POST /payment/init | PUBLIC | success |
