package com.ciandt.talentos.gconf.backend.entities;

import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.HashCodeBuilder;

@Entity
@Table(name = "GC_PALESTRANTE")
public class Palestrante {
		
	@Id
	@SequenceGenerator(name="GC_PALESTRANTE_SEQ")
	@Column(name="ID", nullable=false)
	private Long id;

	@OneToMany(mappedBy="palestrante")
	private Set<Palestra> palestras;

	@Column(name="NOME", nullable=false)
	private String nome;
	
	@Column(name="TITULO", nullable=false)
	private String titulo;
	
	@Column(name="EMAIL", nullable=false)
	private String email;
	
	@Column(name="BIOGRAFIA", nullable=false)
	private String biografia;

	
	public Palestrante() {}
	
	public Palestrante(Long id, String nome, String titulo, String email, String biografia) {
		this.id = id;
		this.nome = nome;
		this.titulo = titulo;
		this.email = email;
		this.biografia = biografia;
	}
	
	public Palestrante(Long id, String nome, String titulo, String email, String biografia, Set<Palestra> palestras) {
		this.id = id;
		this.nome = nome;
		this.titulo = titulo;
		this.email = email;
		this.biografia = biografia;
		this.palestras = palestras;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}
	
	public Set<Palestra> getPalestras() {
		return palestras;
	}
	
	public void setPalestras(Set<Palestra> palestras) {
		this.palestras = palestras;
	}
	
	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	public String getTitulo() {
		return titulo;
	}

	public void setTitulo(String titulo) {
		this.titulo = titulo;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getBiografia() {
		return biografia;
	}

	public void setBiografia(String biografia) {
		this.biografia = biografia;
	}
	
	@Override
	public int hashCode() {
		return new HashCodeBuilder()
				.append(this.getId())
				.toHashCode();
	}

	@Override
	public boolean equals(Object o) {
		if (!(o instanceof Palestrante)) {
			return false;
		}
		return new EqualsBuilder()
				.append(this.getId(), ((Palestrante) o).getId())
				.isEquals();
	}
	

}
