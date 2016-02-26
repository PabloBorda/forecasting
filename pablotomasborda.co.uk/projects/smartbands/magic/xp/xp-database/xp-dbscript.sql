SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
USE `mydb`;

-- -----------------------------------------------------
-- Table `mydb`.`users`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`users` (
  `iduser` INT NOT NULL ,
  `firstname` VARCHAR(100) NOT NULL ,
  `lastname` VARCHAR(100) NOT NULL ,
  `birthdate` VARCHAR(100) NOT NULL ,
  `email` VARCHAR(100) NOT NULL ,
  PRIMARY KEY (`iduser`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`companies`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`companies` (
  `idcompany` INT NOT NULL ,
  `name` VARCHAR(100) NOT NULL ,
  PRIMARY KEY (`idcompany`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`users_has_companies`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`users_has_companies` (
  `users_iduser` INT NOT NULL ,
  `companies_idcompany` INT NOT NULL ,
  `position` VARCHAR(160) NULL ,
  PRIMARY KEY (`users_iduser`, `companies_idcompany`) ,
  INDEX `fk_users_has_companies_users` (`users_iduser` ASC) ,
  INDEX `fk_users_has_companies_companies1` (`companies_idcompany` ASC) ,
  CONSTRAINT `fk_users_has_companies_users`
    FOREIGN KEY (`users_iduser` )
    REFERENCES `mydb`.`users` (`iduser` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_has_companies_companies1`
    FOREIGN KEY (`companies_idcompany` )
    REFERENCES `mydb`.`companies` (`idcompany` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`users_has_users`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`users_has_users` (
  `users_iduser` INT NOT NULL ,
  `users_iduser1` INT NOT NULL ,
  `comparison_value` INT NULL ,
  PRIMARY KEY (`users_iduser`, `users_iduser1`) ,
  INDEX `fk_users_has_users_users1` (`users_iduser` ASC) ,
  INDEX `fk_users_has_users_users2` (`users_iduser1` ASC) ,
  CONSTRAINT `fk_users_has_users_users1`
    FOREIGN KEY (`users_iduser` )
    REFERENCES `mydb`.`users` (`iduser` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_has_users_users2`
    FOREIGN KEY (`users_iduser1` )
    REFERENCES `mydb`.`users` (`iduser` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
