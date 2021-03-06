-- MySQL Script generated by MySQL Workbench
-- Tue Nov 13 16:55:09 2018
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`User`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`User` (
  `ID` VARCHAR(45) NOT NULL,
  `LastName` VARCHAR(45) NULL,
  `FirstName` VARCHAR(45) NULL,
  `Email` VARCHAR(45) NULL,
  `UserGroup` VARCHAR(45) NULL,
  `Password` VARCHAR(45) NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Seminar`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Seminar` (
  `SeminarID` VARCHAR(45) NOT NULL,
  `SeminarName` VARCHAR(45) NULL,
  `Department` VARCHAR(45) NULL,
  `Semester` VARCHAR(45) NULL,
  PRIMARY KEY (`SeminarID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`OrganizedSiminar`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`OrganizedSiminar` (
  `CourseID` INT NOT NULL,
  `OrganizerID` VARCHAR(45) NULL,
  `SeminarID` VARCHAR(45) NULL,
  `Schedual` VARCHAR(45) NULL,
  `Location` VARCHAR(45) NULL,
  `Speaker` VARCHAR(45) NULL,
  `SpeakerLink` VARCHAR(45) NULL,
  INDEX `Seminar_idx` (`SeminarID` ASC) VISIBLE,
  PRIMARY KEY (`CourseID`),
  CONSTRAINT `Organizer`
    FOREIGN KEY (`OrganizerID`)
    REFERENCES `mydb`.`User` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Seminar`
    FOREIGN KEY (`SeminarID`)
    REFERENCES `mydb`.`Seminar` (`SeminarID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Student-Course`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Student-Course` (
  `CourseID` INT NULL,
  `StudentID` VARCHAR(45) NULL,
  INDEX `Course_idx` (`CourseID` ASC) VISIBLE,
  INDEX `Student_idx` (`StudentID` ASC) VISIBLE,
  CONSTRAINT `Course`
    FOREIGN KEY (`CourseID`)
    REFERENCES `mydb`.`OrganizedSiminar` (`CourseID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Student`
    FOREIGN KEY (`StudentID`)
    REFERENCES `mydb`.`User` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
