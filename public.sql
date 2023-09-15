/*
 Navicat Premium Data Transfer

 Source Server         : Postgres14
 Source Server Type    : PostgreSQL
 Source Server Version : 140006 (140006)
 Source Host           : localhost:5432
 Source Catalog        : TestDB
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 140006 (140006)
 File Encoding         : 65001

 Date: 15/09/2023 11:12:10
*/


-- ----------------------------
-- Sequence structure for Category_id_category_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."Category_id_category_seq";
CREATE SEQUENCE "public"."Category_id_category_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for Client_id_client_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."Client_id_client_seq";
CREATE SEQUENCE "public"."Client_id_client_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for Nomenclature_id_nomenclature_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."Nomenclature_id_nomenclature_seq";
CREATE SEQUENCE "public"."Nomenclature_id_nomenclature_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for Order content_id_content_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."Order content_id_content_seq";
CREATE SEQUENCE "public"."Order content_id_content_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for Order_id_order_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."Order_id_order_seq";
CREATE SEQUENCE "public"."Order_id_order_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Table structure for Category
-- ----------------------------
DROP TABLE IF EXISTS "public"."Category";
CREATE TABLE "public"."Category" (
  "id_category" int4 NOT NULL DEFAULT nextval('"Category_id_category_seq"'::regclass),
  "category" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "id_child_category" int4
)
;

-- ----------------------------
-- Records of Category
-- ----------------------------
INSERT INTO "public"."Category" VALUES (1, 'Бытовая техника', NULL);
INSERT INTO "public"."Category" VALUES (2, 'Стиральные машины', 1);
INSERT INTO "public"."Category" VALUES (3, 'Холодильники', 1);
INSERT INTO "public"."Category" VALUES (4, 'Телевизоры', 1);
INSERT INTO "public"."Category" VALUES (5, 'Компьютеры', NULL);
INSERT INTO "public"."Category" VALUES (6, 'Ноутбуки', 5);
INSERT INTO "public"."Category" VALUES (7, 'Моноблоки', 5);

-- ----------------------------
-- Table structure for Client
-- ----------------------------
DROP TABLE IF EXISTS "public"."Client";
CREATE TABLE "public"."Client" (
  "id_client" int4 NOT NULL DEFAULT nextval('"Client_id_client_seq"'::regclass),
  "client" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "address" text COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Records of Client
-- ----------------------------
INSERT INTO "public"."Client" VALUES (1, 'Клиент 1', 'Адрес 1');
INSERT INTO "public"."Client" VALUES (2, 'Клиент 2', 'Адрес 2');
INSERT INTO "public"."Client" VALUES (3, 'Клиент 3', 'Адрес 3');

-- ----------------------------
-- Table structure for Nomenclature
-- ----------------------------
DROP TABLE IF EXISTS "public"."Nomenclature";
CREATE TABLE "public"."Nomenclature" (
  "id_nomenclature" int4 NOT NULL DEFAULT nextval('"Nomenclature_id_nomenclature_seq"'::regclass),
  "nomenclature" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "quantity" int4 NOT NULL,
  "cost" money NOT NULL
)
;

-- ----------------------------
-- Records of Nomenclature
-- ----------------------------
INSERT INTO "public"."Nomenclature" VALUES (1, 'Товар 1', 10, '100,00 ?');
INSERT INTO "public"."Nomenclature" VALUES (2, 'Товар 2', 5, '50,00 ?');
INSERT INTO "public"."Nomenclature" VALUES (3, 'Товар 3', 20, '200,00 ?');
INSERT INTO "public"."Nomenclature" VALUES (4, 'Товар 4', 15, '150,00 ?');
INSERT INTO "public"."Nomenclature" VALUES (5, 'Товар 5', 8, '80,00 ?');

-- ----------------------------
-- Table structure for Order
-- ----------------------------
DROP TABLE IF EXISTS "public"."Order";
CREATE TABLE "public"."Order" (
  "id_order" int4 NOT NULL DEFAULT nextval('"Order_id_order_seq"'::regclass),
  "id_client" int4 NOT NULL,
  "date" date NOT NULL
)
;

-- ----------------------------
-- Records of Order
-- ----------------------------
INSERT INTO "public"."Order" VALUES (1, 1, '2023-09-15');
INSERT INTO "public"."Order" VALUES (2, 2, '2023-09-14');
INSERT INTO "public"."Order" VALUES (3, 3, '2023-09-13');

-- ----------------------------
-- Table structure for Order content
-- ----------------------------
DROP TABLE IF EXISTS "public"."Order content";
CREATE TABLE "public"."Order content" (
  "id_content" int4 NOT NULL DEFAULT nextval('"Order content_id_content_seq"'::regclass),
  "id_order" int4 NOT NULL,
  "id_nomenclature" int4 NOT NULL,
  "quantity" int4
)
;

-- ----------------------------
-- Records of Order content
-- ----------------------------
INSERT INTO "public"."Order content" VALUES (1, 1, 1, 2);
INSERT INTO "public"."Order content" VALUES (2, 1, 3, 5);
INSERT INTO "public"."Order content" VALUES (3, 2, 2, 3);
INSERT INTO "public"."Order content" VALUES (4, 3, 4, 4);
INSERT INTO "public"."Order content" VALUES (5, 3, 5, 2);

-- ----------------------------
-- View structure for FirstQuery
-- ----------------------------
DROP VIEW IF EXISTS "public"."FirstQuery";
CREATE VIEW "public"."FirstQuery" AS  SELECT c.client AS "Наименование клиента",
    sum(n.cost::numeric * oc.quantity::numeric) AS "Сумма"
   FROM "Client" c
     JOIN "Order" o ON c.id_client = o.id_client
     JOIN "Order content" oc ON o.id_order = oc.id_order
     JOIN "Nomenclature" n ON oc.id_nomenclature = n.id_nomenclature
  GROUP BY c.client
  ORDER BY c.client;

-- ----------------------------
-- View structure for SecondQuery
-- ----------------------------
DROP VIEW IF EXISTS "public"."SecondQuery";
CREATE VIEW "public"."SecondQuery" AS  SELECT parent.category AS "Категория",
    count(child.id_category) AS "Количество дочерних элементов"
   FROM "Category" parent
     LEFT JOIN "Category" child ON parent.id_category = child.id_child_category
  GROUP BY parent.category
  ORDER BY parent.category;

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."Category_id_category_seq"
OWNED BY "public"."Category"."id_category";
SELECT setval('"public"."Category_id_category_seq"', 7, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."Client_id_client_seq"
OWNED BY "public"."Client"."id_client";
SELECT setval('"public"."Client_id_client_seq"', 3, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."Nomenclature_id_nomenclature_seq"
OWNED BY "public"."Nomenclature"."id_nomenclature";
SELECT setval('"public"."Nomenclature_id_nomenclature_seq"', 5, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."Order content_id_content_seq"
OWNED BY "public"."Order content"."id_content";
SELECT setval('"public"."Order content_id_content_seq"', 5, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."Order_id_order_seq"
OWNED BY "public"."Order"."id_order";
SELECT setval('"public"."Order_id_order_seq"', 3, true);

-- ----------------------------
-- Primary Key structure for table Category
-- ----------------------------
ALTER TABLE "public"."Category" ADD CONSTRAINT "Category_pkey" PRIMARY KEY ("id_category");

-- ----------------------------
-- Primary Key structure for table Client
-- ----------------------------
ALTER TABLE "public"."Client" ADD CONSTRAINT "Client_pkey" PRIMARY KEY ("id_client");

-- ----------------------------
-- Primary Key structure for table Nomenclature
-- ----------------------------
ALTER TABLE "public"."Nomenclature" ADD CONSTRAINT "Nomenclature_pkey" PRIMARY KEY ("id_nomenclature");

-- ----------------------------
-- Primary Key structure for table Order
-- ----------------------------
ALTER TABLE "public"."Order" ADD CONSTRAINT "Order_pkey" PRIMARY KEY ("id_order");

-- ----------------------------
-- Primary Key structure for table Order content
-- ----------------------------
ALTER TABLE "public"."Order content" ADD CONSTRAINT "Order content_pkey" PRIMARY KEY ("id_content");

-- ----------------------------
-- Foreign Keys structure for table Category
-- ----------------------------
ALTER TABLE "public"."Category" ADD CONSTRAINT "Category_id_child_category_fkey" FOREIGN KEY ("id_child_category") REFERENCES "public"."Category" ("id_category") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table Order
-- ----------------------------
ALTER TABLE "public"."Order" ADD CONSTRAINT "Order_id_client_fkey" FOREIGN KEY ("id_client") REFERENCES "public"."Client" ("id_client") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table Order content
-- ----------------------------
ALTER TABLE "public"."Order content" ADD CONSTRAINT "Order content_id_nomenclature_fkey" FOREIGN KEY ("id_nomenclature") REFERENCES "public"."Nomenclature" ("id_nomenclature") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "public"."Order content" ADD CONSTRAINT "Order content_id_order_fkey" FOREIGN KEY ("id_order") REFERENCES "public"."Order" ("id_order") ON DELETE CASCADE ON UPDATE CASCADE;
