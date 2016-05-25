/*
 * generated by Xtext
 */
package io.yaktor;

import org.eclipse.xtext.generator.IOutputConfigurationProvider;

import com.google.inject.Binder;
import com.google.inject.Singleton;
import io.yaktor.generator.DomainOutputConfigurationProvider;
import io.yaktor.generator.util.CommentExtensions;

/**
 * Use this class to register components to be used at runtime / without the Equinox extension registry.
 */
public class DomainRuntimeModule extends io.yaktor.AbstractDomainRuntimeModule {
	@Override
	public void configure(Binder binder) {
		super.configure(binder);
		binder.requestStaticInjection(CommentExtensions.class);
		binder.bind(IOutputConfigurationProvider.class)
			.to(DomainOutputConfigurationProvider.class)
			.in(Singleton.class);
	}
}