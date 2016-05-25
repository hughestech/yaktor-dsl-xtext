/*
 * generated by Xtext
 */
package io.yaktor.validation

import io.yaktor.domain.AssociationEnd
import io.yaktor.domain.Constraint
import io.yaktor.domain.DomainModel
import io.yaktor.domain.Entity
import io.yaktor.domain.Field
import io.yaktor.domain.GenOptions
import io.yaktor.domain.JpaGenOptions
import io.yaktor.domain.MongoNodeGenOptions
import io.yaktor.domain.NamedType
import io.yaktor.domain.UniqueConstraint
import io.yaktor.util.DslDomainUtil
import org.eclipse.xtext.validation.Check

import static extension io.yaktor.generator.nodejs.NodeJsExtensions.*

/**
 * Custom validation rules. 
 *
 * see http://www.eclipse.org/Xtext/documentation.html#validation
 */
class DomainValidator extends AbstractDomainValidator {
  private def checkName(String name, GenOptions options) {
    if (!name.matches("[A-Za-z][A-za-z0-9_]*[A-za-z0-9]?")) {
      error("The name should match the allowed pattern", null);
    } else if (options != null && (options instanceof JpaGenOptions)) {
      if (DslDomainUtil.isJavaKeyword(name)) {
        error("Name [" + name + "] not allowed: Java keyword", null);
      } else {
        if (DslDomainUtil.isOracleKeyword(name.toUpperCase())) {
          error("Name [" + name + "] not allowed: Oracle keyword", null);
        }
      }
    } else if (options != null && (options instanceof MongoNodeGenOptions)) {
      if (DslDomainUtil.isJavascriptKeyword(name)) {
        error("Name [" + name + "] not allowed: Javascript keyword", null);
      }
    }
  }

  @Check
  def void checkNameMatchesPattern(NamedType typ) {
    if (typ.eContainer() instanceof DomainModel) {
      checkName(typ.getName(), (typ.eContainer as DomainModel).genOptions);
    }
  }

  @Check
  def void checkConstraint(Constraint ic) {
    if (ic.eContainer.eContainer instanceof DomainModel &&
      (ic.eContainer.eContainer as DomainModel).genOptions instanceof JpaGenOptions) {
      val icc = ic.eContainer
      for (f : ic.fields.filter[f|f.eContainer != icc]) {
        error("field [" + f.name + "] must be a top level field", null);
      }
    }
  }
  
  @Check
  def void checkConstraintMongo(Entity e) {
    if (e.eContainer instanceof DomainModel &&
      (e.eContainer as DomainModel).genOptions instanceof MongoNodeGenOptions) {
        if(e.supertype != null && !e.supertype.isAbstract)
      error("Mongo Entities may only extend an abstract Entity", null);
    }
  }

  @Check
  def void checkUniqueConstraint(UniqueConstraint ic) {
    if (ic.eContainer instanceof Entity) {
      var e = ic.eContainer as Entity
      var root = e.rootEntity
      // TODO consider jpa...
      // If you require a discriminator but aren't the root then ...
      if (e.requiresDiscriminator &&  root != e) {
        val fields = root.allFields
        for (f : ic.fields.filter[f|!fields.contains(f)]) {
          error("unique field [" + f.name + "] not allowed. Unique fields must be shared by all sub-types", null);
        }
      }
    }
  }

  @Check
  def void checkNameMatchesPattern(Field typ) {
    if (typ.eContainer().eContainer() instanceof DomainModel) {
      checkName(typ.getName(), (typ.eContainer().eContainer() as DomainModel).genOptions);
    }
  }

  @Check
  def void checkNameMatchesPattern(AssociationEnd asc) {
    if (asc.eContainer().eContainer() instanceof DomainModel) {
      checkName(asc.getName(), (asc.eContainer().eContainer() as DomainModel).genOptions);
    }
  }

}