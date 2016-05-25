/*
 * generated by Xtext
 */
package io.yaktor.formatting

import com.google.inject.Inject
import org.eclipse.xtext.formatting.impl.AbstractDeclarativeFormatter
import org.eclipse.xtext.formatting.impl.FormattingConfig
import io.yaktor.services.DomainGrammarAccess

/**
 * This class contains custom formatting description.
 * 
 * see : http://www.eclipse.org/Xtext/documentation.html#formatting
 * on how and when to use it 
 * 
 * Also see {@link org.eclipse.xtext.xtext.XtextFormattingTokenSerializer} as an example
 */
public class DomainFormatter extends AbstractDeclarativeFormatter {

  @Inject extension DomainGrammarAccess

  override protected configureFormatting(FormattingConfig c) {
    for (pair : findKeywordPairs('{', '}')) {
      c.setIndentation(pair.first, pair.second)
      c.setLinewrap(1).after(pair.first)
      c.setLinewrap(1).before(pair.second)
      c.setLinewrap(1).after(pair.second)
    }
    for (comma : findKeywords(',')) {
      c.setNoLinewrap().before(comma)
      c.setNoSpace().before(comma)
      c.setLinewrap().after(comma)
    }
    c.setLinewrap(0, 1, 2).before(SL_COMMENTRule)
    c.setLinewrap(0, 1, 2).before(ML_COMMENTRule)
    c.setLinewrap(0, 1, 1).after(ML_COMMENTRule)

    c.setNoLinewrap().before(cardinalityRule)
    c.setNoSpace().before(cardinalityRule)
    c.setLinewrap(1, 1, 1).after(fieldRule);

    c.setLinewrap(1, 1, 1).after(domainModelImportRule);
    c.setLinewrap(1, 1, 1).after(associationEndRule);
    c.setLinewrap(1, 1, 1).after(uniqueConstraintRule);
    c.setLinewrap(1, 1, 1).after(indexConstraintRule);
    
    
    for (ex : findKeywords('extensions')) {
      c.setLinewrap().before(ex)
    }
    
    c.setLinewrap(1, 1, 1).after(jpaTableOptionsRule);
    c.setLinewrap(1, 1, 1).after(mongoNodeTableOptionsRule);
  }
}